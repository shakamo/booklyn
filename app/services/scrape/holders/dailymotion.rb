require 'open-uri'
require 'nokogiri'
require 'chronic'
require 'uri'

module Scrape::Holders
  class Dailymotion < Holder
    def execute(url, trim_title, episode_num)
      episode = get_episode(trim_title, episode_num)

      holder_name = 'Dailymotion'

      document = Common::UrlUtils.instance.get_document(url)

      platform_name = 'PC'
      post = create_post(url, episode, holder_name, platform_name)

      if document == nil
        post.available = 'NG'
        post.error = 'ResponseCode is 4xx'
      elsif document.css('div.media-block > div').inner_text != ''
        post.available = 'NG'
        post.error = document.css('div.media-block > div').inner_text
        return
      elsif episode != nil
        post.available = 'OK'
      else
        post.available = 'INSPECTION'
        post.error = ''
      end
      post.save
    end

    def execute_by_user(user_id)
      index = 1

      while true do

        url = 'https://api.dailymotion.com/videos?fields=language,status%2Ctitle%2Curl&owners=' + user_id + '&sort=recent&limit=10&page=' + index.to_s
        json = Common::UrlUtils.instance.get_json(url)

        # TODO
        json['list'].each do |item|
          title = item['title']
            
            Common::RegexUtils.get_trim_title
        end

        if json['has_more']
          index += 1
        else
          break
        end
      end
    end
  end
end
