ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../../../config/environment', __FILE__)
require 'open-uri'
require 'nokogiri'
require 'utils'
require 'chronic'
require 'uri'

require 'minitest/unit'
require 'minitest/autorun'

# lib/common/regex_utils.rb
module Scrape::Holders
  class TestUtils
    def setup
    end
  end
end
