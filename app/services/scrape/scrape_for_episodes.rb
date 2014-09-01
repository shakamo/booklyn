require 'open-uri'
require 'nokogiri'
require 'utils'
require 'chronic'
require 'uri'

module Scrape
  class ScrapeForEpisodes
    def self.execute()
      url = 'http://tvanimedouga.blog93.fc2.com/archives.html'
      

      url = 'http://tvanimedouga.blog93.fc2.com/?all&p=6'
      ScrapeTvanimedouga.execute(url)
      url = 'http://tvanimedouga.blog93.fc2.com/?all&p=7'
      ScrapeTvanimedouga.execute(url)
      url = 'http://tvanimedouga.blog93.fc2.com/?all&p=8'
      ScrapeTvanimedouga.execute(url)
    end
  end
end
