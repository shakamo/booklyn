require 'open-uri'
require 'nokogiri'
require 'utils'
require 'chronic'
require 'uri'

module Scrape
  class ScrapeTvanimedouga
    def self.execute(url)
      @doc_factory = Utils::NokogiriDocumentFactory.new
      document = @doc_factory.get_document_for_tvanimedouga(url)

      node = document.css('#blog_achives > div > dl > dt > a.entry_title')
      node.each do |item|
        full_episode_num = item.inner_text.scan(/[\s　]+(第[0-9]{1,3}話)/)
        if full_episode_num != nil
          full_episode_num = full_episode_num.flatten
          full_episode_num = full_episode_num.compact
          full_episode_num = full_episode_num[0]
        else
          error = Error.find_or_initialize_by(name: 'ScrapeTvanimedougaNotFoundEpisodeNum', description: item.inner_text)
          error.save
          next
        end
        title = item.inner_text.sub(full_episode_num, '')
        trim_title = Utils.trim(title)

        episode_num = full_episode_num.sub('第','').sub('話','')

        url = "http://tvanimedouga.blog93.fc2.com/" + item.attribute('href').value

        get_tvanimedouga_detail(url, trim_title, episode_num)
      end
    end

    def self.get_tvanimedouga_detail(url, trim_title, episode_num)
      document = @doc_factory.get_document(url)

      sub_title = document.css('#mainBlock > div.mainEntryBlock > div.mainEntryBase > div.mainEntryBody').inner_text
      sub_title = sub_title.scan(/話「(.*)」/)

      sub_title = sub_title.flatten
      sub_title = sub_title.compact
      sub_title = sub_title[0]

      if sub_title
      else
        # sub_title = document.css('#mainBlock > div.mainEntryBlock > div.mainEntryBase > div.mainEntryBody').inner_text
        # error = Error.find_or_initialize_by(name: 'ScrapeTvanimedougaNotFoundSubTitle', description: sub_title, url: url)
        # error.save
        sub_title = nil
      end

      list = document.css('#mainBlock > div.mainEntryBlock > div.mainEntryBase > div.mainEntrykiji > a')
      list.each do |item|
        holder_name = item.inner_text.sub('【','').sub('】','')

        if !(holder_name.index('検索】'))
          unescape_url = item.attribute('href').value

          url = URI.escape(unescape_url)

          if url.index('http://himado.in/?sort=&')
          elsif url.index('http://himado.in/?keyword=')
          elsif url.index('http://www.nosub.tv/?s=%')
          elsif url.index('http://www.veoh.com/find/?query')
          else
            ScrapeForPosts.register_post(holder_name, url, trim_title, episode_num)
          end
        end
      end
    end
  end
end
