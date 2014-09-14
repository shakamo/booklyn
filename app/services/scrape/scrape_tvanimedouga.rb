require 'open-uri'
require 'nokogiri'
require 'chronic'
require 'uri'

module Scrape
  class ScrapeTvanimedouga
    def self.execute(url)
      
      document = Common::UrlUtils.instance.get_document(url)

      node = document.css('#blog_achives > div > dl > dt > a.entry_title')
      node.each do |item|
        begin
          episode_num = Common::RegexUtils.get_episode_num(item.inner_text)
        rescue
          error = Error.find_or_initialize_by(name: 'ScrapeTvanimedougaNotFoundEpisodeNum', description: item.inner_text)
          error.save
          next
        end

        begin
          trim_title = Common::RegexUtils.get_trim_title(item.inner_text)
        rescue
          error = Error.find_or_initialize_by(name: 'ScrapeTvanimedougaNotFoundTitle', description: item.inner_text)
          error.save
          next
        end

        url = "http://tvanimedouga.blog93.fc2.com/" + item.attribute('href').value
        get_tvanimedouga_detail(url, trim_title, episode_num)
      end
    end

    def self.get_tvanimedouga_detail(url, trim_title, episode_num)
      document = Common::UrlUtils.instance.get_document(url)

      begin
        sub_title = Common::RegexUtils.get_sub_title(document.css('#mainBlock > div.mainEntryBlock > div.mainEntryBase > div.mainEntryBody').inner_text)
      rescue
      end

      list = document.css('#mainBlock > div.mainEntryBlock > div.mainEntryBase > div.mainEntrykiji > a')
      list.each do |item|
        holder_name = item.inner_text.sub('【','').sub('】','')

        if !(holder_name.index('検索'))
          unescape_url = item.attribute('href').value
          url = URI.escape(unescape_url)

          if url.index('http://himado.in/?sort=&')
          elsif url.index('http://himado.in/?keyword=')
          elsif url.index('http://www.nosub.tv/?s=%')
          elsif url.index('http://www.veoh.com/find/?query')
          else
            Holders::ScrapeForPosts.register_post(holder_name, url, trim_title, episode_num)
          end
        end
      end
    end
  end
end
