ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../../../../config/environment', __FILE__)
require 'open-uri'
require 'nokogiri'
require 'logger'
require 'net/http'
require 'uri'
require 'minitest/unit'
require 'minitest/autorun'

module Scrape::Holders
  class TestHolder < MiniTest::Unit::TestCase
    def setup
    end
  end
end
