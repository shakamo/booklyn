require 'singleton'
require 'open-uri'
require 'nokogiri'
require 'logger'
require 'net/http'
require 'net/https'
require 'uri'
require 'json'

module Common
  class UrlUtils
    include Singleton

    @contents = nil
    def initialize
      @contents = Hash.new
    end

    def get_document(url, redirect = false)
      if @contents.has_key?(url) then
        return @contents[url]
      end

      if url?(url) == false
        return nil
      end

      url = URI.parse(url)
      Net::HTTP.version_1_2

      html = Net::HTTP.start(url.host, url.port) do |http|
        path = url.path.to_s
        if 0 < url.query.to_s.length
          path << '?' + url.query.to_s
        end
        res = http.get(path)

        case res
        when Net::HTTPSuccess then
          res.response.body
        when Net::HTTPRedirection then
          if redirect
            return nil
          else
            loc = res.fetch 'location'
            if url?(loc)
              p "redirected to #{loc}"
              return get_document(loc, true)
            end

            loc = 'http://' + url.host.to_s + ':' + url.port.to_s + loc
            if url?(loc)
              p "redirected to #{loc}"
              return get_document(loc, true)
            end

            return nil
          end
        else
          if res.code == '410'
            return nil
          elsif res.code == '403'
            return nil
          elsif res.code == '404'
            return nil
          elsif res.code == '502'
            return nil
          else
            return nil
          end
        end
      end

      @contents[url] = Nokogiri::HTML.parse(html, nil)
      return @contents[url]
    end

    def get_document_for_anikore(year, season, page)
      get_document(url)
    end

    def get_document_for_anikore_by_detail(content_id)
      url = 'http://www.anikore.jp/anime/' + content_id.to_s
      get_document(url)
    end

    def get_document_for_shoboi(content, type)

      if content.title == '蟲師 続章（後半エピソード）'
        result_search = get_document(URI.encode('http://cal.syoboi.jp/find?sd=0&kw=蟲師 続章(第2期)&ch=&st=&cm=&r=0&rd=&v=0'))
      else
        result_search = get_document(URI.encode('http://cal.syoboi.jp/find?sd=0&kw=' + content.title + '&ch=&st=&cm=&r=0&rd=&v=0'))
      end

      result_doc = result_search.css('#main > table > tr > td > table.tframe > tr > td > a')

      if result_doc == nil || result_doc.length == 0
        return nil
      else
        path = result_doc[0][:href]
      end

      url = 'http://cal.syoboi.jp' + path + '/' + type
      url?(url)
      get_document(url)
    end

    def get_document_for_posite(year, season)
      season = "01" if season == "winter"
      season = "04" if season == "spring"
      season = "07" if season == "summer"
      season = "10" if season == "autumn"

      key = year + season
      url = 'http://www.posite-c.com/anime/weekly/?' + key

      get_document(url)
    end

    def check_direct_url(direct_url)
      regex = direct_url.scan(/.*\.(mp4|ogv|webm)$/i).flatten.compact[0]
      if regex == nil
        p direct_url
        return false
      elsif url?(direct_url) == false
        p direct_url
        return false
      end

      url = URI.parse(direct_url)
      Net::HTTP.version_1_2

      begin
        html = Net::HTTP.start(url.host, url.port) do |http|
          path = url.path.to_s
          if 0 < url.query.to_s.length
            path << '?' + url.query.to_s
          end

          res = http.head(path)

          if res.code == '200'
            return true
          else
            return false
          end
        end
      rescue
        p direct_url
      end
    end

    def get_json(url)      if @contents.has_key?(url) then
        return @contents[url]
      end

      url = URI.parse(url)
      Net::HTTP.version_1_2

      https = Net::HTTP.new(url.host, 443)
      https.use_ssl = true
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE

      response = https.start do |http|
        path = url.path.to_s
        if 0 < url.query.to_s.length
          path << '?' + url.query.to_s
        end

        res = http.get(path)
        res.response.body
      end

      JSON.parse(response)
    end

    def url?(str)
      begin
        uri = URI.parse(str)
      rescue
        p 'This is not url.' + str
        return false
      end
      return uri.scheme == 'http' || uri.scheme == 'https'
    end
  end
end

