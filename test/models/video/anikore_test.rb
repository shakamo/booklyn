require 'test_helper'
require 'video/anikore'

# Anikore Test
class AnikoreTest < ActiveSupport::TestCase
  def setup
    @anikore = Video::Anikore.new
  end

  def test_get_max_page_size
    assert_equal 3, @anikore.get_max_page_size(2015, :winter, :tv)
  end

  def test_import_images
    @anikore.import_images('http://www.anikore.jp/chronicle/2015/winter/ac:tv/page:2')
  end

  def test_1
    @anikore.save_image('8881','')
  end
end
