require 'open-uri'
require 'nokogiri'
require 'utils'
require 'chronic'
require 'uri'

module Scrape
  class Holder
    def create_post(url, episode, holder_name, platform_name)
      post = Post.find_or_initialize_by(url: url)
      if episode
        post.episode_id = episode.id
      else
        post.url = url
      end
      contents_holder = ContentsHolder.find_or_initialize_by(contents_holder_name: holder_name)
      post.contents_holder_id = contents_holder.id

      platform = Platform.find_or_initialize_by(platform_name: platform_name)
      post.platform_id = platform.id

      return post
    end
  end

  class ScrapeForPosts
    @@Contents = %w(ひまわり B9 Saymove anitube NoSub Videofan Ｖｅｏｈ)
    def self.register_post(holder_name, url, episode)
      holder = nil
      case holder_name
      when 'ひまわり'
        holder = Himawari.new
      when 'Himawari'
        holder = Himawari.new
      when 'B9'
        holder = B9.new
      when 'B9DM'
        holder = B9.new
      when 'NoSub'
        holder = Nosub.new
      when 'Ｖｅｏｈ'
        holder = Veoh.new
      when 'Veoh'
        holder = Veoh.new
      when 'SayMove'
        holder = SayMove.new
      when 'Dailymotion'
        holder = Dailymotion.new
      else
        if holder_name.index('検索')
        elsif holder_name.index('動画一覧')
        else
          p 'unknown ' + holder_name
        end
      end

      if holder
        holder.execute(url, episode)
      end
    end
  end

  class Himawari < Holder
    def execute(url, episode)
      holder_name = 'ひまわり動画'
      @doc_factory = Utils::NokogiriDocumentFactory.new
      document = @doc_factory.get_document(url)

      platform_name = 'All'
      post = create_post(url, episode, holder_name, platform_name)
      if document.css('#link_disablemessag_own').inner_text != ''
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
          post.direct_url = URI.unescape(direct_url).sub('external:','')
        end
      else
        post.available = 'INSPECTION'
        post.error = document.css('#movie_title').inner_text
      end

      
      post.save
    end
  end

  class B9 < Holder
    def execute(url, episode)
      holder_name = 'B9DM'

      @doc_factory = Utils::NokogiriDocumentFactory.new
      document = @doc_factory.get_document(url)

      platform_name = 'PC'
      post = create_post(url, episode, holder_name, platform_name)

      if false
        post.available = 'NG'
        post.error = ''
      elsif episode != nil
        post.available = 'OK'
      else
        post.available = 'INSPECTION'
        post.error = document.css('.caption > h3').inner_text
      end
      post.save
    end
  end

  class Nosub < Holder
    def execute(url, episode)
      holder_name = 'Nosub'

      @doc_factory = Utils::NokogiriDocumentFactory.new
      document = @doc_factory.get_document(url)

      platform_name = 'PC'
      post = create_post(url, episode, holder_name, platform_name)

      if document.css('.error_404_return').inner_text != ''
        post.available = 'NG'
        post.error = '404'
      elsif episode != nil
        post.available = 'OK'
      else
        post.available = 'INSPECTION'
        post.error = document.css('h1').inner_text
      end
      post.save
    end
  end

  class Veoh < Holder
    def execute(url, episode)
      holder_name = 'Veoh'

      @doc_factory = Utils::NokogiriDocumentFactory.new
      document = @doc_factory.get_document(url)

      platform_name = 'PC'
      post = create_post(url, episode, holder_name, platform_name)

      ## TO-DO
      if false
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

  class SayMove < Holder
    def execute(url, episode)
      holder_name = 'SayMove'

      @doc_factory = Utils::NokogiriDocumentFactory.new
      document = @doc_factory.get_document(url)

      platform_name = 'PC'
      post = create_post(url, episode, holder_name, platform_name)

      if false
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

  class Dailymotion < Holder
    def execute(url, episode)
      holder_name = 'Dailymotion'

      @doc_factory = Utils::NokogiriDocumentFactory.new
      document = @doc_factory.get_document(url)

      platform_name = 'PC'
      post = create_post(url, episode, holder_name, platform_name)

      if false
        post.available = 'NG'
        post.error = ''
        return
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