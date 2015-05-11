require 'test_helper'
require 'video/anikore'

# Anikore Test
class AnikoreTest < ActiveSupport::TestCase
  def setup
    @@anikore = Video::Anikore.new
  end

  def test_get_max_page_size
    assert_equal 3, @@anikore.get_max_page_size(2015, :winter, :tv)
  end

  def test_import_titles
    # @@anikore.import_titles('http://www.anikore.jp/chronicle/2015/winter/ac:tv/page:2', 2015, :winter, :tv)
  end

  def test_import_titles
    # @@anikore.import_titles('http://www.anikore.jp/chronicle/2015/winter/ac:tv/page:2', 2015, :winter, :tv)
  end
end
