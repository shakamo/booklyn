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
    assert_raises StandardError do
      @anikore.import_images('http://www.anikore.jp/chronicle/2015/winter/ac:tv/page:2')
    end
  end

  def test_save_image
    @anikore.save_image(2282, 99992)
  end

  def test_save_image2
    @anikore.save_image(8895, 99992)
  end
end
