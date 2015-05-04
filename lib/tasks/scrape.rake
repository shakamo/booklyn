desc "Contentsを取得する。"
task :scrape => :environment do
  Rails.env = "test"

  Rake::Task["scrape:anikore"].invoke
end

namespace :scrape do
  Rails.env = "test"

  desc "perform task that import Anikore."
  task :anikore => :environment do
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

  desc "Run tests quickly, but also reset db"
  task :run => %w[scrape:deprecate_all scrape:run]

  Rake::Task["scrape:run"].enhance do
    puts "4"
    Rake::Task["scrape:deprecate_all"].invoke
  end

end
