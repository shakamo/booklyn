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
          episode.save
        else
          episode = nil
        end

        url = item.attribute('href').value

        get_tvanimedouga_detail(url, episode)
      end
    end

    def self.get_tvanimedouga_detail(url, episode)

      document = @doc_factory.get_document(url)
      list = document.css('#mainBlock > div.mainEntryBlock > div.mainEntryBase > div.mainEntrykiji > a')

      if episode && episode.episode_name == nil
        sub_title = document.css('#mainBlock > div.mainEntryBlock > div.mainEntryBase > div.mainEntryBody').inner_text
        p sub_title
        sub_title = sub_title.scan(/話「.*」/)
        if sub_title.size == 1
          sub_title = sub_title[0]
          sub_title = sub_title.slice(2,sub_title.size()-3)
          p sub_title
          episode.episode_name = sub_title
          episode.save
        end
      end

      list.each do |item|
        holder_name = item.inner_text

        if !(holder_name.index('検索】'))
          url = item.attribute('href').value

          if url.index('sortby')
          elsif url.index('keyword')
          else
            ScrapeForPosts.register_post(holder_name, url, episode)
          end
        end
      end
    end
  end
end
