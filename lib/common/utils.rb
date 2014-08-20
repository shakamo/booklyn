require 'open-uri'
require 'nokogiri'
require 'logger'
require 'utils'

module Utils
  class NokogiriDocumentFactory

    @anikore = nil
    @anikore_detail = nil
    @posite = nil
    def initialize
      @anikore = Hash.new
      @anikore_detail = Hash.new
      @posite = Hash.new
    end

    def get_document(url)
      charset = nil
      html = open(url) do |f|
        charset = f.charset
        f.read
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
  end
end
