require 'open-uri'
require 'nokogiri'
require 'logger'
require 'net/http'
require 'uri'

module Utils
  class NokogiriDocumentFactory

    @anikore = nil
    @anikore_detail = nil
    @posite = nil
    @tvanimedouga = nil
    def initialize
      @anikore = Hash.new
      @anikore_detail = Hash.new
      @posite = Hash.new
      @tvanimedouga = Hash.new
    end

    def get_document(url)
      begin
        charset = nil
        html = open(url) do |f|
          charset = f.charset
        end
      rescue
      end
      
      url = URI.parse(url)
      Net::HTTP.version_1_2

      html = Net::HTTP.start(url.host, url.port) do |http|
        http.get('/').response.body
      end
p charset


      return doc = Nokogiri::HTML.parse(html, nil, charset)
    end

    def get_document_for_anikore(year, season, page)
      key = year + season + page.to_s

      if @anikore.has_key?(key) then
        return @anikore[key]
      end
      url = 'http://www.anikore.jp/chronicle/' + year + '/' + season +'/page:' + page.to_s
      @anikore[key] = get_document(url)
      return @anikore[key]
    end

    def get_document_for_anikore_by_detail(content_id)
      if @anikore_detail.has_key?(content_id) then
        return @anikore_detail[content_id]
      end
      url = 'http://www.anikore.jp/anime/' + content_id.to_s
      @anikore_detail[content_id] = get_document(url)
      return @anikore_detail[content_id]
    end

    def get_document_for_posite(title, year, season)
      season = "01" if season == "winter"
      season = "04" if season == "spring"
      season = "07" if season == "summer"
      season = "10" if season == "autumn"

      key = year + season

      if @posite.has_key?(key) then
        return @posite[key]
      end
      url = 'http://www.posite-c.com/anime/weekly/?' + key
      @posite[key] = get_document(url)
      return @posite[key]
    end

    def get_document_for_tvanimedouga(url)
      key = "main"

      if @tvanimedouga.has_key?(key) then
        return @tvanimedouga[key]
      end
      @tvanimedouga[key] = get_document(url)
      return @tvanimedouga[key]
    end
  end

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

  WEEKS = %w(Sun Mon Tue Wed Thu Fri Sat)
  TRIM_STR = %w(・ - ! ！ [ ] { } / | ^ ~ = @ ` : * ; + _ ? > < . " # $ % & ' ¥( ¥) ¥¥ ☆ ★ ？ ＿ ＞ ＜ 、 。 」 「 『 』 ＠ ｀ ： ＊ ； ＋ ｜ ￥ ＾ 〜 ー ＝ ” ＃ ＄ ％ ＆ ’ （ ）)
end
