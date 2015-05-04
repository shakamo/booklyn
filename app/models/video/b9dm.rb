require 'open-uri'
require 'nokogiri'
require 'chronic'
require 'uri'

module Scrape::Post
  class B9dm < Holder
    def execute(url, content, episode)
      holder_name = 'B9DM'

      document = Common::UrlUtils.instance.get_document(url)

      platform_name = 'PC'
      post = create_post(url, episode, holder_name, platform_name)

      if document == nil
        post.available = 'NG'
        post.error = 'ResponseCode is 4xx'
      elsif false
        post.available = 'NG'
        post.error = ''
      elsif episode != nil
        post.available = 'OK'
      else
        post.available = 'INSPECTION'
        post.error = document.css('.caption > h3').inner_text
      end
      post.save
    end
  end
end