require 'open-uri'
require 'nokogiri'
require 'utils'
require 'chronic'
require 'uri'

module Scrape
  class ScrapeForEpisodes
    def self.execute()
      ScrapeTvanimedouga.execute
    end
  end
end
