require 'open-uri'
require 'nokogiri'
require 'utils'
require 'chronic'
require 'uri'

module Scrape::Holders
  class SayMove < Holder
    def execute(url, trim_title, episode_num)
      episode = get_episode(trim_title, episode_num)

      holder_name = 'SayMove'

      @doc_factory = Utils::NokogiriDocumentFactory.new
      document = @doc_factory.get_document(url)

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
        post.error = ''
      end
      post.save
    end
  end
end