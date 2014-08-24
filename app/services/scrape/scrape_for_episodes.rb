require 'open-uri'
require 'nokogiri'
require 'utils'
require 'chronic'
require 'uri'

module Scrape
  class ScrapeForEpisodes
    def self.execute()
      ScrapeTvanimedouga.execute
    end
  end

  class ScrapeTvanimedouga
    def self.execute()
      @doc_factory = Utils::NokogiriDocumentFactory.new
      document = @doc_factory.get_document_for_tvanimedouga()

      node = document.css('#mainBlock > div.index_area > div > div > a')
      node.each do |item|
        episode_num = item.inner_text.scan(/　第[0-9]{1,3}話/)[0]
        title = item.inner_text.sub(episode_num, '')

        title = Utils.trim(title)
        episode_num = episode_num.sub('　第','').sub('話','')

        contents = Content.where(Content.arel_table[:trim_title].matches('%' + title + '%'))
        if contents && contents.size == 1
          episode = Episode.find_or_initialize_by(content_id: contents.first.id, episode_num: episode_num)
          episode_id = episode.id
        else
          episode_id = nil
        end

        url = item.attribute('href').value
        get_tvanimedouga_detail(url, episode_id)
      end
    end

    def self.get_tvanimedouga_detail(url, episode_id)

      document = @doc_factory.get_document(url)
      list = document.css('#mainBlock > div.mainEntryBlock > div.mainEntryBase > div.mainEntrykiji > a')

      list.each do |item|
        holder_name = item.inner_text

        if !(holder_name.index('検索】'))
          url = item.attribute('href').value

          ScrapeForPosts.register_post(holder_name, url, episode_id)
        end
      end
    end
  end
end
