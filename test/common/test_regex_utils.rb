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
      str = 'HUNTER×HUNTER　第146話'
      assert_equal '146', RegexUtils.get_episode_num(str)
      assert_equal '第146話', RegexUtils.get_episode_string(str)
      assert_equal 'HUNTER×HUNTER', RegexUtils.get_title(str)
      assert_equal 'HUNTER×HUNTER', RegexUtils.get_title_trim(str)
      assert_equal 'HUNTER×HUNTER', RegexUtils.get_title_query(str)
      assert_nil RegexUtils.get_title_for_anikore(str)
      assert_nil RegexUtils.get_sub_title(RegexUtils.get_title(str))
    end

    def test_2
      str = 'アカメが斬る！　第特別総集編 1話'
      assert_equal '1', RegexUtils.get_episode_num(str)
      assert_equal '1話', RegexUtils.get_episode_string(str)
      assert_equal 'アカメが斬る！　第特別総集編', RegexUtils.get_title(str)
      assert_equal 'アカメが斬る第特別総集編', RegexUtils.get_title_trim(str)
      assert_equal 'アカメが斬る%第特別総集編', RegexUtils.get_title_query(str)
      assert_nil RegexUtils.get_title_for_anikore(str)
      assert_nil RegexUtils.get_sub_title(RegexUtils.get_title(str))
    end

    def test_3
      str = '少年ハリウッド－ＨＯＬＬＹ　ＳＴＡＧＥ　ＦＯＲ　４９－  「望まれない僕たち」 - ひまわり動画'
      assert_nil RegexUtils.get_episode_num(str)
      assert_nil RegexUtils.get_episode_string(str)
      assert_equal '少年ハリウッド－ＨＯＬＬＹ　ＳＴＡＧＥ　ＦＯＲ　４９－', RegexUtils.get_title(str)
      assert_equal '少年ハリウッドＨＯＬＬＹＳＴＡＧＥＦＯＲ４９', RegexUtils.get_title_trim(str)
      assert_equal '少年ハリウッド%ＨＯＬＬＹ%ＳＴＡＧＥ%ＦＯＲ%４９%', RegexUtils.get_title_query(str)
      assert_nil RegexUtils.get_title_for_anikore(str)
      assert_equal '望まれない僕たち', RegexUtils.get_sub_title(str)
    end

    def test_4
      str = '六畳間の侵略者！？ 第09話 「陽だまりと虹」 - ひまわり動画'
      assert_equal '9', RegexUtils.get_episode_num(str)
      assert_equal '第09話', RegexUtils.get_episode_string(str)
      assert_equal '六畳間の侵略者！？', RegexUtils.get_title(str)
      assert_equal '六畳間の侵略者', RegexUtils.get_title_trim(str)
      assert_equal '六畳間の侵略者%', RegexUtils.get_title_query(str)
      assert_nil RegexUtils.get_title_for_anikore(str)
      assert_equal '陽だまりと虹', RegexUtils.get_sub_title(str)
    end

    def test_5
      str = 'ひめゴト #08 「はじめてだから優しくしてください」 - ひまわり動画'
      assert_equal '8', RegexUtils.get_episode_num(str)
      assert_equal '#08', RegexUtils.get_episode_string(str)
      assert_equal 'ひめゴト', RegexUtils.get_title(str)
      assert_equal 'ひめゴト', RegexUtils.get_title_trim(str)
      assert_equal 'ひめゴト', RegexUtils.get_title_query(str)
      assert_nil RegexUtils.get_title_for_anikore(str)
      assert_equal 'はじめてだから優しくしてください', RegexUtils.get_sub_title(str)
    end

    def test_6
      str = 'あの夏で待ってる OVA ねこちゃんＢＤ高画質「僕達は高校最後の夏を過ごしながら、あの夏を待っている。」 - ひまわり動画'
      assert_nil RegexUtils.get_episode_num(str)
      assert_nil RegexUtils.get_episode_string(str)
      assert_equal 'あの夏で待ってる OVA', RegexUtils.get_title(str)
      assert_equal 'あの夏で待ってるOVA', RegexUtils.get_title_trim(str)
      assert_equal 'あの夏で待ってる%OVA', RegexUtils.get_title_query(str)
      assert_nil RegexUtils.get_title_for_anikore(str)
      assert_equal '僕達は高校最後の夏を過ごしながら、あの夏を待っている。', RegexUtils.get_sub_title(str)
    end

    def test_7
      str = 'ログ・ホライズン 第2シリーズ　第13話'
      assert_equal '13', RegexUtils.get_episode_num(str)
      assert_equal '第13話', RegexUtils.get_episode_string(str)
      assert_equal 'ログ・ホライズン 第2シリーズ', RegexUtils.get_title(str)
      assert_equal 'ログホライズン第2シリズ', RegexUtils.get_title_trim(str)
      assert_equal 'ログ%ホライズン%第2シリ%ズ', RegexUtils.get_title_query(str)
      assert_nil RegexUtils.get_title_for_anikore(str)
      assert_nil RegexUtils.get_sub_title(str)
    end

    def test_8
      str = 'まじっく快斗1412　第12話'
      assert_equal '12', RegexUtils.get_episode_num(str)
      assert_equal '第12話', RegexUtils.get_episode_string(str)
      assert_equal 'まじっく快斗1412', RegexUtils.get_title(str)
      assert_equal 'まじっく快斗1412', RegexUtils.get_title_trim(str)
      assert_equal 'まじっく快斗1412', RegexUtils.get_title_query(str)
      assert_nil RegexUtils.get_title_for_anikore(str)
      assert_nil RegexUtils.get_sub_title(str)
    end
  end
end
