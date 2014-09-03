
task :scraping_episodes => :environment do
    Scrape::ScrapeForEpisodes.execute()
end

task :scraping => :environment do

    Scrape::ScrapeForContents.execute("2011", "winter")
end

task :te => :environment do
e = Episode.find_or_initialize_by(id:70)
    Scrape::ScrapeForPosts.register_post("ひまわり","http://himado.in/234128", e)
end
