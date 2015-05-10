require 'test_helper'
require 'nokogiri_utils'

# Nokogiri Utility
class NokogiriUtilsTest < ActiveSupport::TestCase
  include NokogiriUtils
  def setup
  end

  def test_1
    assert html('<html></html>')
  end
end
