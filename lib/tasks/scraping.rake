task :scraping => :environment do

    @test = Scrape::Scraping.execute("2014", "summer")
end
