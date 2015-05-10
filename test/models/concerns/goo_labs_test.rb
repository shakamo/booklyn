require 'test_helper'
require 'goo_labs'

# GooLabs Test
class GooLabsTest < ActiveSupport::TestCase
  include GooLabs

  def setup
  end

  def test_1
    array = call_morph('まじっく快斗1412　第12話')
    assert_equal array.size, 3
    assert_equal array[:raw].size, 10
    assert_equal array[:morph].size, 10
    assert_equal array[:kana].size, 10
  end
end
