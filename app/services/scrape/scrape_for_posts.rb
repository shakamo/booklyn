require 'open-uri'
require 'nokogiri'
require 'utils'
require 'chronic'
require 'uri'

module Scrape
  class ScrapeForPosts
    @@Contents = %w(【ひまわり】 【B9】 【Saymove】 【anitube】 【NoSub】 【Videofan】 【Ｖｅｏｈ】)
    def self.register_post(holder_name, url, episode_id)
      holder = nil

      case holder_name
      when @@Contents[0]
        holder = Himawari.new
      when @@Contents[1]
        holder = B9.new
      else
      end

      if holder
        holder.execute(url, episode_id)
      end
    end
  end

  class Himawari
    def execute(url, episode_id)
      p 'execute Himawari'
      @doc_factory = Utils::NokogiriDocumentFactory.new
      document = @doc_factory.get_document(url)

      if episode_id
        post = Post.find_or_initialize_by(episode_id: episode_id, url: url)
      else
        post = Post.new
        post.url = url
      end

      contents_holder = ContentsHolder.find_or_initialize_by(contents_holder_code: "01")
      post.contents_holder_id = contents_holder.id

      if document.css('#link_disablemessag_own').inner_text != ''
        post.available = 'NG'
        return
      elsif episode_id != nil
        post.available = 'OK'
      else
        post.available = 'INSPECTION'
      end

      platform = Platform.find_or_initialize_by(platform_code: '1')
      post.platform_id = platform.id

      script = document.css('#player > script').inner_text
      direct_url = script.scan(/var movie_url = ['].*[']/)[0]
      if direct_url
        direct_url = direct_url[0].scan(/['].*[']/)[0]
        if direct_url
          direct_url.gsub("'",'').gsub('?','')
          post.direct_url = direct_url
        end
      end

    end
  end

  class B9
    def execute(url, episode_id)
      p 'execute B9'
    end
  end

  class Holder
    def self.register()
    end
  end
end