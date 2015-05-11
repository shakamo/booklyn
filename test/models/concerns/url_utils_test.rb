require 'test_helper'
require 'url_utils'

# GooLabs Test
class UrlUtilsTest < ActiveSupport::TestCase
  include UrlUtils
  def setup
  end

  def test_1
    get_body('http://htaccess1.cman.jp/sample/redirect/site/')
  end

  def test_2
    doc = get_body('http://cal.syoboi.jp/db.php?Command=TitleLookup&TID=1')
    puts Nokogiri::XML(doc)
  end
end
