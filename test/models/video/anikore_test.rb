require 'test_helper'
require 'video/anikore'

# Anikore Test
class AnikoreTest < ActiveSupport::TestCase
  def setup
  end

  def test_get_max_page_size
    anikore = Video::Anikore.new
    assert_equal 3, anikore.get_max_page_size(2015, :winter, 'ac:tv')
  end
end
