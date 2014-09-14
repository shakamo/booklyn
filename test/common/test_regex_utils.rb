ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../../config/environment', __FILE__)
require 'open-uri'
require 'nokogiri'
require 'logger'
require 'net/http'
require 'uri'
require 'minitest/unit'
require 'minitest/autorun'

module Common
  class TestRegexUtils < MiniTest::Unit::TestCase
    def setup
    end

    def test_1
      result = RegexUtils.get_episode_num(' HUNTER×HUNTER　第146話')
      assert_equal '146',result
    end

    def test_2
      result = RegexUtils.get_episode_num('アカメが斬る！　第特別総集編 1話')
      assert_equal '1',result
    end

    def test_11
      result = RegexUtils.get_title('アカメが斬る！　第特別総集編 1話')
      assert_equal 'アカメが斬る第特別総集編',result
    end

    def test_12
      result = RegexUtils.get_title('Fate kaleid liner プリズマ☆イリヤ 2wei！　第10話')
      assert_equal 'FATEKALEIDLINERプリズマイリヤ2WEI', result
    end
  end
end
