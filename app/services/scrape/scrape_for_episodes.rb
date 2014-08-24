require 'open-uri'
require 'nokogiri'
require 'utils'
require 'chronic'

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
        temp = item.inner_text.scan(/　第[0-9]{1,3}話/)[0]
        title = item.inner_text.sub(temp,'')
        temp = temp.sub('　第','').sub('話','')

        contents = Content.where(Content.arel_table[:title].matches('%' + title + '%'))
        p title
        p temp
        p contents.size
        episode_id = 0
        url = item.attribute('href').value
        get_tvanimedouga_detail(title, url, episode_id)
      end
    end

    def self.get_tvanimedouga_detail(title, url, episode_id)

      document = @doc_factory.get_document(url)
      list = document.css('#mainBlock > div.mainEntryBlock > div.mainEntryBase > div.mainEntrykiji > a')

      list.each do |item|
        holder_name = item.inner_text

        if !(holder_name.index('検索】'))
          url = item.attribute('href').value

          ContentsHolder.register_post(holder_name, url, episode_id)
        end
      end
    end
  end
end
