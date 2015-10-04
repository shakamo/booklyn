# Daily Jobs
desc 'Latest Contentsを取得する。'
task shoboi_latest: :environment do
  ImportContents.new.perform_all(:Shoboi, 2015, :Winter, 3)
end

desc 'TermFrequencyを登録する。'
task term_frequency: :environment do
  RegisterTfidf.new.execute
end

desc 'Imageを取得する。'
task image: :environment do
  ImportContents.new.perform_all(:Anikore, 2015, :spring, 90)
end

# Rescue Jobs
desc 'Contentsを取得する。'
task shoboi_three_month: :environment do
  ImportContents.new.perform_all(:Shoboi, nil, nil, 90)
end

desc 'Tvanimedougaを登録する。'
task tvanimedouga: :environment do
  Video::Tvanimedouga.new.import_page
end

namespace :scrape do
  desc 'perform task that import Anikore.'
  task anikore: :environment do
    ImportContents.new.perform_all(:Anikore, 2015, :spring)
  end

  # Scrape::ScrapeForContents.execute("2014", "spring")
  # Scrape::ContentManager.createAll("Anikore", "2014", "summer")
  # Scrape::ContentManager.createAll("Anikore", "2015", "winter")

  # Scrape::ContentManager.createAll('Rakuten', '', 'autumn')
  # Scrape::ContentManager.createAll('Rakuten', '', 'winter')
  #  task :scrape_contents_rakuten => :environment do
  #    ImportContents.performAll(:Rakuten, nil, :autumn)
  #    ImportContents.performAll(:Rakuten, nil, :winter)
  #  end

  desc 'Run tests quickly, but also reset db'
  task run: %w(scrape:deprecate_all scrape:run)

  Rake::Task['scrape:run'].enhance do
    Rake::Task['scrape:deprecate_all'].invoke
  end
end

namespace :db do
  fixtures_dir = Rails.root.to_s + '/test/fixtures/tmp/'
  namespace :fixtures do
    desc 'Extract database data to the tmp/fixtures/ directory. Use FIXTURES=table_name[,table_name...] to specify table names to extract. Otherwise, all the table data will be extracted.'
    task extract: :environment do
      sql = 'SELECT * FROM %s ORDER BY id'
      skip_tables = %w(schema_info schema_migrations)
      ActiveRecord::Base.establish_connection
      FileUtils.mkdir_p(fixtures_dir)

      if ENV['FIXTURES']
        table_names = ENV['FIXTURES'].split(/,/)
      else
        table_names = (ActiveRecord::Base.connection.tables - skip_tables)
      end

      table_names.each do |table_name|
        File.open(fixtures_dir + table_name + '.yml', 'w') do |file|
          puts file.path
          puts file.to_s
          objects = ActiveRecord::Base.connection.select_all(sql % table_name)
          objects.each do |obj|
            file.write fixture_entry(table_name, obj) + "\n\n"
          end
        end
      end
    end
  end
end

def fixture_entry(table_name, obj)
  res = []
  klass = table_name.singularize.camelize.constantize
  res << "#{table_name.singularize}#{obj['id']}:"
  klass.columns.each do |column|
    res << "  #{column.name}: #{obj[column.name]}"
  end
  res.join("\n")
end
