require 'test_helper'
require 'goo_labs'

# GooLabs Test
class GooLabsTest < ActiveSupport::TestCase
  include GooLabs

  def setup
  end

  def test_get_morph
    Rails.application.config.goo_api_key_num = 1
    array = call_morph('まじっく快斗1412　第12話')
    assert_equal array.size, 3
    assert_equal array[:raw].size, 10
    assert_equal array[:morph].size, 10
    assert_equal array[:kana].size, 10
  end

  def test_api_key_num
    Rails.application.config.goo_api_key_num = 1
    GooLabs.stub :call_morph, {:raw=>["第", "12", "話"], :morph=>["冠数詞", "Number", "助数詞"], :kana=>["ダイ", "ジューニ", "ワ"]} do
      array = call_morph('第12話')
      assert_equal array.size, 3
      assert_equal array[:raw].size, 3
      assert_equal array[:morph].size, 3
      assert_equal array[:kana].size, 3
    end
  end

  def test_key_1
    Rails.application.config.goo_api_key_num = 11
    assert get_api_key
  end

  def test_key_2
    assert_raises StandardError do
      Rails.application.config.goo_api_key_num = 13
      get_api_key
    end
  end
end
