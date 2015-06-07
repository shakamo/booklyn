require 'open-uri'
require 'nokogiri'
require 'chronic'

module Video
  class B9dm
    include Holder, UrlUtils
    def execute(url, _content, episode)
      holder_name = 'B9DM'
      doc = get_body(url)

      platform_name = 'PC'
      post = create_post(url, episode, holder_name, platform_name)

      if doc.nil?
        post.available = 'NG'
        post.error = 'ResponseCode is 4xx'
      elsif false
        post.available = 'NG'
        post.error = ''
      elsif !episode.nil?
        post.available = 'OK'
      else
        post.available = 'INSPECTION'
        post.error = doc.css('.caption > h3').inner_text
      end
      post.save
    end
  end
end
