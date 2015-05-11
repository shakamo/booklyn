require 'open-uri'
require 'nokogiri'
require 'chronic'
require 'uri'

module Video
  class Veoh
    include Holder
    def execute(url, _content, episode)
      holder_name = 'Veoh'

      document = get_body(url)

      platform_name = 'PC'
      post = create_post(url, episode, holder_name, platform_name)

      ## TO-DO

      if document.nil?
        post.available = 'NG'
        post.error = 'ResponseCode is 4xx'
      elsif false
        post.available = 'NG'
        post.error = ''
      elsif !episode.nil?
        post.available = 'OK'
      else
        post.available = 'INSPECTION'
        post.error = ''
      end
      post.save
    end
  end
end