
task :scraping_episodes => :environment do
    Scrape::ScrapeForEpisodes.execute()
end

task :scraping => :environment do

    Scrape::ScrapeForContents.execute("2012", "winter")
end
