require 'open-uri'
require 'nokogiri'
require 'logger'
require 'net/http'
require 'uri'

class Utils
  WEEKS = %w(Sun Mon Tue Wed Thu Fri Sat)
  TRIM_STR = %w(・ - ! ！ [ ] { } / | ^ ~ = @ ` : * ; + _ ? > < . " # $ % & ' ¥( ¥) ¥¥ ☆ ★ ？ ＿ ＞ ＜ 、 。 」 「 『 』 ＠ ｀ ： ＊ ； ＋ ｜ ￥ ＾ 〜 ー ＝ ” ＃ ＄ ％ ＆ ’ （ ） － ～ ／)

  def self.trim(value)
    value = value.strip.to_s
    valur = value.gsub(/^[\s　]+|[\s　]+$/, '')
  end

  def self.multi_trim(value)
    trim_value = String.new(value)

    TRIM_STR.each do |str|
      trim_value.gsub!(str, '')
    end

    trim_value.gsub!(' ', '')
    trim_value.gsub!('　', '')
    trim_value
  end

  def self.query_trim(value)
    trim_value = String.new(value)

    TRIM_STR.each do |str|
      trim_value.gsub!(str, '%')
    end

    trim_value.gsub!(' ', '%')
    trim_value.gsub!('　', '%')
    trim_value.gsub!('%%', '%')
    trim_value
  end

  def self.regex_trim(value)
    trim_value = query_trim(value)

    trim_value.gsub!('%', '.*')
    trim_value
  end

  def self.Weeks(num)
    WEEKS[num]
  end
end
