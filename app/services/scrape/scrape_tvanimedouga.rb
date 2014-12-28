require 'open-uri'
require 'nokogiri'
require 'chronic'
require 'uri'

module Scrape
  class ScrapeTvanimedouga
    @@url = 'http://tvanimedouga.blog93.fc2.com/?all&p=1'

    def self.createAll()

      document = Common::UrlUtils.instance.get_document(@@url)

      node = document.css('#blog_achives > div > dl > dt > a.entry_title')
      node.each do |item|
        load_episode(item)
      end
    end

    def self.update(count)

      document = Common::UrlUtils.instance.get_document(@@url)

      node = document.css('#blog_achives > div > dl > dt > a.entry_title')
      count.times do |index|
        load_episode(node[index])
      end
    end

    def self.load_episode(item)
      title = Common::RegexUtils.get_title(item.inner_text)
      title_query = Common::RegexUtils.get_title_query(item.inner_text)
      title_trim = Common::RegexUtils.get_title_trim(item.inner_text)
      episode_num = Common::RegexUtils.get_episode_num(item.inner_text)
      content = Scrape::ContentManager.get_content(title_query)
      if content != nil then
        episode = Scrape::EpisodeManager.get_episode(content, episode_num)
      end
      path = item.attribute('href').value
      load_tvanimedouga_detail(path, content, episode)
    end

    def self.load_tvanimedouga_detail(path, content, episode)
      detail_url = "http://tvanimedouga.blog93.fc2.com/" + path
      document = Common::UrlUtils.instance.get_document(detail_url)

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
            Scrape::PostManager.register_post(holder_name, url, content, episode)
          end
        end
      end
    end
  end
end
