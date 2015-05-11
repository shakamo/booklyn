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

    # ?以降のパラメータを追加する
    if 0 < uri.query.to_s.length
      uri.path << '?' + uri.query.to_s
    end

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
