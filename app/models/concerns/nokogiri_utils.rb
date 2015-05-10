require 'active_support/concern'
require 'nokogiri'

# URL Utility
module NokogiriUtils
  extend ActiveSupport::Concern

  def html(body)
    Nokogiri::HTML(body)
  end
end
