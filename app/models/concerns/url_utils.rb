require 'active_support/concern'
require 'uri'
require 'open-uri'
require 'net/http'
require 'net/https'
require 'kconv'
require 'json'

# URL Utility
module UrlUtils
  extend ActiveSupport::Concern

  def get_body(url, redirect = 3)
    uri = URI.parse(url)
    return nil if uri.host.blank?

    # ?以降のパラメータを追加する
    uri.path << '?' + uri.query.to_s if 0 < uri.query.to_s.length
    req = Net::HTTP::Get.new(uri.path)
    http = Net::HTTP.new(uri.host, uri.port)

    begin
      res = http.start do |con|
        con.request(req)
      end
      return response_handler(res, redirect, url) do |redirect_url|
        get_body(redirect_url, redirect - 1)
      end
    rescue => e
      raise(StandardError, e.message + '!!' + url, e.backtrace)
    end
  end

  def post_body_ssl(url, form_data, redirect = 3)
    uri = URI.parse(url)
    req = Net::HTTP::Post.new(uri.path)
    req.set_form_data(form_data, ';')

    http = Net::HTTP.new(uri.host, 443)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    begin
      res = http.start do |con|
        con.request(req)
      end

      return response_handler(res, redirect, url) do |redirect_url|
        post_body_ssl(redirect_url, form_data, redirect - 1)
      end
    rescue => e
      raise(StandardError, e.message + '!!' + url, e.backtrace)
    end
  end

  def response_handler(res, redirect, url)
    case res
    when Net::HTTPSuccess
      return Nokogiri::HTML(res.body.toutf8, nil, 'utf-8')
    when Net::HTTPRedirection
      Rails.logger.info 'HTTPRedirection Error ' + url if redirect <= 0
      return yield res['location']
    when Net::HTTPBadRequest
      Rails.logger.info 'BadRequest Error ' + url
    when Net::HTTPGone
      Rails.logger.info 'HTTPGone Error ' + url
    when Net::HTTPNotFound
      Rails.logger.info 'HTTPNotFound' + url
    else
      Rails.logger.info 'Unknown Error ' + url
    end
    nil
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

  def url?(str)
    begin
      uri = URI.parse(str)
    rescue
      p 'This is not url.' + str
      return false
    end
    uri.scheme == 'http' || uri.scheme == 'https'
  end
end
