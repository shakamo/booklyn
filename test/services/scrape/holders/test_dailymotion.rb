ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../../../../config/environment', __FILE__)
require 'open-uri'
require 'nokogiri'
require 'utils'
require 'chronic'
require 'uri'

require 'minitest/unit'
require 'minitest/autorun'
module Scrape::Holders
  class TestDailymotion
    def setup
    end
  end
end
