require 'open-uri'
require 'nokogiri'
require 'chronic'
require 'uri'

module Video
  class Dailymotion
    include Holder
    def execute(url, _content, episode)
      holder_name = 'Dailymotion'

      document = get_body(url)

      platform_name = 'PC'
      post = create_post(url, episode, holder_name, platform_name)

      if document.nil?
        post.available = 'NG'
        post.error = 'ResponseCode is 4xx'
      elsif document.css('div.media-block > div').inner_text != ''
        post.available = 'NG'
        post.error = document.css('div.media-block > div').inner_text
        return
      elsif !episode.nil?
        post.available = 'OK'
      else
        post.available = 'INSPECTION'
        post.error = ''
      end
      post.save
    end

    def execute_by_user(user_id)
      index = 1

      loop do
        url = 'https://api.dailymotion.com/videos?fields=language,status%2Ctitle%2Curl&owners=' + user_id + '&sort=recent&limit=10&page=' + index.to_s
        json = Common::UrlUtils.instance.get_json(url)

        json['list'].each do |item|
          title = item['title']
          begin

            trim_title = Common::RegexUtils.get_trim_title(title)
            episode_num = Common::RegexUtils.get_episode_num(title)
            sub_title = Common::RegexUtils.get_sub_title(title)
            url = item['url']

            holder = Holder.new

            episode = holder.get_episode(trim_title, episode_num)
            if episode

              episode.episode_name = sub_title
              holder.create_post(url, episode, 'Dailymotion', 'All')
            else
              p title
            end

          rescue => e
            p e
          end
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
