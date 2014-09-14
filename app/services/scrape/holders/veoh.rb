require 'open-uri'
require 'nokogiri'
require 'chronic'
require 'uri'

module Scrape::Holders
  class Veoh < Holder
    def execute(url, trim_title, episode_num)
      episode = get_episode(trim_title, episode_num)

      holder_name = 'Veoh'

      document = Common::UrlUtils.instance.get_document(url)

      platform_name = 'PC'
      post = create_post(url, episode, holder_name, platform_name)

      ## TO-DO

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
        post.error = ''
      end
      post.save
    end
  end
end