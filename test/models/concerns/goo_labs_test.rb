require 'test_helper'
require 'goo_labs'

# GooLabs Test
class GooLabsTest < ActiveSupport::TestCase
  include GooLabs

  def setup
  end

  def test_1
    Rails.application.config.goo_api_key_num = 1
    array = call_morph('まじっく快斗1412　第12話')
    assert_equal array.size, 3
    assert_equal array[:raw].size, 10
    assert_equal array[:morph].size, 10
    assert_equal array[:kana].size, 10
  end

  def test_2
    Rails.application.config.goo_api_key_num = 2
    array = call_morph('まじっく快斗1412　第12話')
    assert_equal array.size, 3
    assert_equal array[:raw].size, 10
    assert_equal array[:morph].size, 10
    assert_equal array[:kana].size, 10
  end

  def test_3
    Rails.application.config.goo_api_key_num = 3
    array = call_morph('まじっく快斗1412　第12話')
    assert_equal array.size, 3
    assert_equal array[:raw].size, 10
    assert_equal array[:morph].size, 10
    assert_equal array[:kana].size, 10
  end

  def test_4
    Rails.application.config.goo_api_key_num = 4
    array = call_morph('まじっく快斗1412　第12話')
    assert_equal array.size, 3
    assert_equal array[:raw].size, 10
    assert_equal array[:morph].size, 10
    assert_equal array[:kana].size, 10
  end

  def test_5
    assert_raises StandardError do
      Rails.application.config.goo_api_key_num = 12
      array = call_morph('まじっく快斗1412　第12話')
      assert_equal array.size, 3
      assert_equal array[:raw].size, 10
      assert_equal array[:morph].size, 10
      assert_equal array[:kana].size, 10
    end
  end

  def test_key_1
    Rails.application.config.goo_api_key_num = 11
    assert get_api_key
  end

  def test_key_2
    assert_raises StandardError do
      Rails.application.config.goo_api_key_num = 12
      get_api_key
    end
  end
end
