require 'open-uri'
require 'nokogiri'
require 'logger'

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
          f.read
        end
      rescue
        p '☆get_document(url): ' + url 
      end

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

    def get_document_for_tvanimedouga()
      key = "main"

      if @tvanimedouga.has_key?(key) then
        return @tvanimedouga[key]
      end
      url = 'http://tvanimedouga.blog93.fc2.com/archives.html'
      @tvanimedouga[key] = get_document(url)
      return @tvanimedouga[key]
    end
  end

  def self.trim(str)
    str = String.new(str)
    str.gsub!('・','')
    str.gsub!('-','')
    str.gsub!('!','')
    str.gsub!('！','')
    str.gsub!(' ','')
    str.gsub!('　','')
    return str
  end

  def self.Weeks(num)
    return WEEKS[num]
  end

  WEEKS = %w(Sun Mon Tue Wed Thu Fri Sat)
end
