require 'open-uri'
require 'nokogiri'
require 'chronic'
require 'uri'

module Scrape
  class ScrapeForEpisodes
    def self.executeTvanimedouga(url)
      ScrapeTvanimedouga.execute(url)
    end
  end
end
