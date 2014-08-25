require 'open-uri'
require 'nokogiri'
require 'utils'
require 'chronic'
require 'uri'

module Scrape
  class ScrapeForPosts
    @@Contents = %w(【ひまわり】 【B9】 【Saymove】 【anitube】 【NoSub】 【Videofan】 【Ｖｅｏｈ】)
    def self.register_post(holder_name, url, episode)
      holder = nil
      case holder_name
      when @@Contents[0]
        holder = Himawari.new
      when @@Contents[1]
        holder = B9.new
      else
      end

      if holder
        holder.execute(url, episode)
      end
    end
  end

  class Himawari
    def execute(url, episode)
      p 'execute Himawari ' + episode.to_s + ' ' + url
      @doc_factory = Utils::NokogiriDocumentFactory.new
      document = @doc_factory.get_document(url)

      post = Post.find_or_initialize_by(url: url)
      if episode
        post.episode_id = episode.id
      else
        post.url = url
      end

      contents_holder = ContentsHolder.find_or_initialize_by(contents_holder_code: "01")
      post.contents_holder_id = contents_holder.id

      if document.css('#link_disablemessag_own').inner_text != ''
        post.available = 'NG'
        post.error = document.css('#link_disablemessag_own').inner_text
        return
      elsif episode != nil
        post.available = 'OK'
      else
        post.available = 'INSPECTION'
        post.error = document.css('#movie_title').inner_text
      end

      platform = Platform.find_or_initialize_by(platform_code: '1')
      post.platform_id = platform.id

      script = document.css('#player > script').inner_text
      
      direct_url = nil
      /var movie_url = (?<direct_url>['].*['])/=~ script
      if direct_url
        direct_url = direct_url.gsub("'","").gsub('?','')
        post.direct_url = URI.unescape(direct_url).sub('external:','')
      end
      post.save

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