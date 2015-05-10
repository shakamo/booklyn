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
end
