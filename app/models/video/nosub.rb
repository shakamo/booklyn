require 'open-uri'
require 'nokogiri'
require 'chronic'
require 'uri'

module Video
  class Nosub
    include Holder
    def execute(url, _content, episode)
      holder_name = 'Nosub'

      document = get_body(url)

      platform_name = 'PC'
      post = create_post(url, episode, holder_name, platform_name)

      if document.nil?
        post.available = 'NG'
        post.error = 'ResponseCode is 4xx'
      elsif document.css('.error_404_return').inner_text != ''
        post.available = 'NG'
        post.error = '404'
      elsif !episode.nil?
        post.available = 'OK'
      else
        post.available = 'INSPECTION'
        post.error = document.css('h1').inner_text
      end
      post.save
    end
  end
end