require 'active_support/concern'
require 'uri'
require 'open-uri'
require 'net/http'
require 'net/https'
require 'json'

# URL Utility
module UrlUtils
  extend ActiveSupport::Concern

  def get_body(url, redirect = 3)
    uri = URI.parse(url)
    req = Net::HTTP::Get.new(uri.path)

    http = Net::HTTP.new(uri.host, uri.port)
    res = http.start do |con|
      con.request(req)
    end
    response_handler(res, redirect) do |redirect_url|
      get_body(redirect_url, redirect - 1)
    end
  end

  def post_body_ssl(url, form_data, redirect = 3)
    uri = URI.parse(url)
    req = Net::HTTP::Post.new(uri.path)
    req.set_form_data(form_data, ';')

    http = Net::HTTP.new(uri.host, 443)
    http.use_ssl = true
    res = http.start do |con|
      con.request(req)
    end
    response_handler(res, redirect) do |redirect_url|
      post_body_ssl(redirect_url, form_data, redirect - 1)
    end
  end

  def response_handler(res, redirect)
    case res
    when Net::HTTPSuccess
      res.body
    when Net::HTTPRedirection
      fail 'HTTPRedirection Error' if redirect <= 0
      yield res['location']
    when Net::HTTPBadRequest
      fail 'BadRequest Error'
    else
      fail 'Unknown Error'
    end
  end

  def get_document_for_shoboi(content, type)
    if content.title == '蟲師 続章（後半エピソード）'
      result_search = get_document(URI.encode('http://cal.syoboi.jp/find?sd=0&kw=蟲師 続章(第2期)&ch=&st=&cm=&r=0&rd=&v=0'))
    else
      result_search = get_document(URI.encode('http://cal.syoboi.jp/find?sd=0&kw=' + content.title + '&ch=&st=&cm=&r=0&rd=&v=0'))
    end

    result_doc = result_search.css('#main > table > tr > td > table.tframe > tr > td > a')

    if result_doc.nil? || result_doc.length == 0
      return nil
    else
      path = result_doc[0][:href]
    end

    url = 'http://cal.syoboi.jp' + path + '/' + type
    url?(url)
    get_document(url)
  end

  def get_document_for_posite(year, season)
    season = '01' if season == 'winter'
    season = '04' if season == 'spring'
    season = '07' if season == 'summer'
    season = '10' if season == 'autumn'

    key = year + season
    url = 'http://www.posite-c.com/anime/weekly/?' + key

    get_document(url)
  end

  def check_direct_url(direct_url)
    regex = direct_url.scan(/.*\.(mp4|ogv|webm)$/i).flatten.compact[0]
    if regex.nil?
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
        path << '?' + url.query.to_s if 0 < url.query.to_s.length

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
end
