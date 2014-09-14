require 'open-uri'
require 'nokogiri'
require 'logger'
require 'net/http'
require 'uri'

module Common
  class Utils

    def self.trim(value)
      trim_value = String.new(value)

      TRIM_STR.each do |str|
        trim_value.gsub!(str, '')
      end

      trim_value.gsub!(' ','')
      trim_value.gsub!('　','')
      return trim_value
    end

    def self.Weeks(num)
      return WEEKS[num]
    end
  end

  WEEKS = %w(Sun Mon Tue Wed Thu Fri Sat)
  TRIM_STR = %w(・ - ! ！ [ ] { } / | ^ ~ = @ ` : * ; + _ ? > < . " # $ % & ' ¥( ¥) ¥¥ ☆ ★ ？ ＿ ＞ ＜ 、 。 」 「 『 』 ＠ ｀ ： ＊ ； ＋ ｜ ￥ ＾ 〜 ー ＝ ” ＃ ＄ ％ ＆ ’ （ ） － ～ ／)
end

