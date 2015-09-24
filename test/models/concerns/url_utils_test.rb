require 'test_helper'
require 'url_utils'

# GooLabs Test
class UrlUtilsTest < ActiveSupport::TestCase
  include UrlUtils
  def setup
  end

  def test_1
    assert get_body('http://htaccess1.cman.jp/sample_go/redirect/site/')
  end

  def test_2
    assert get_body('http://cal.syoboi.jp/db.php?Command=TitleLookup&TID=1')
  end
end
