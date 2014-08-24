require 'open-uri'
require 'nokogiri'
require 'utils'
require 'chronic'

module Scrape
  class ContentsHolder
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
      Post.find_or_initialize_by(episode_id: episode_id, url: url)
      
      @doc_factory = Utils::NokogiriDocumentFactory.new
      document = @doc_factory.get_document(url)
      script = document.css('#player > script').inner_text
      p script.scan(/var movie_url = ['].*[']/)[0].scan(/['].*[']/)[0].gsub("'",'')
    end
  end

  class B9
    def execute(url, episode_id)
p 'b9'
    end
  end

  class Holder
    def self.register()
    end
  end
end