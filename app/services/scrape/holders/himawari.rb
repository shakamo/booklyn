require 'open-uri'
require 'nokogiri'
require 'chronic'
require 'uri'

module Scrape::Holders
  class Himawari < Holder
    def execute(url, trim_title, episode_num)
      episode = get_episode(trim_title, episode_num)

      holder_name = 'ひまわり動画'
      
      document = Common::UrlUtils.instance.get_document(url)

      platform_name = 'All'
      post = create_post(url, episode, holder_name, platform_name)

      if document == nil
        post.available = 'NG'
        post.error = 'ResponseCode is 4xx'
      elsif document.css('#link_disablemessag_own').inner_text != ''
        post.available = 'NG'
        post.error = document.css('#link_disablemessag_own').inner_text
      elsif document.css('#link_disablemessage_rights').inner_text != ''
        post.available = 'NG'
        post.error = document.css('#link_disablemessage_rights').inner_text
      elsif episode != nil
        post.available = 'OK'

        direct_url = nil
        script = document.css('#player > script').inner_text
        /var movie_url = (?<direct_url>['].*['])/=~ script
        if direct_url
          direct_url = direct_url.gsub("'","").gsub('?','')
          direct_url = URI.unescape(direct_url).sub('external:','')
          save_direct_url(direct_url, post)
        end
      else
        post.available = 'INSPECTION'
        post.error = document.css('#movie_title').inner_text
      end

      post.save
    end
  end
end