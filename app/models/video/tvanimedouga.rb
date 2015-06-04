require 'open-uri'
require 'nokogiri'
require 'chronic'
require 'uri'

module Video
  #
  class Tvanimedouga
    include GooLabs, TfIdf

    def initialize
      Time.zone = 'Asia/Tokyo'
      Chronic.time_class = Time.zone
    end

    def import_all
      for num in 3..30 do
        import_page(num)
      end
    end
    handle_asynchronously :import_all

    def import_page(num = 1)
      get_list(num).each do |item|
        morph = call_morph(item[:title])

        content = get_content(morph)
        return if content.nil?

        episode = get_episode(morph, content)
        next if episode.nil?

        import_detail(item[:path], content, episode)
      end
    end

    def get_list(num = 1)
      url = Settings.tvanimedouga.url + num.to_s
      list = []

      docs = Nokogiri::XML(get_body(url))

      contents = docs.css('#blog_achives > div > dl > dt > a.entry_title')
      contents.each do |content|
        item = {}
        item[:title] = content.inner_text
        item[:path] = content.attribute('href').value

        list << item
      end

      list
    end

    def get_content(morph)
      tfidf = get_tfidf(morph)
      return nil if tfidf.nil?

      return Content.find_by id: tfidf['content_id']
    end

    def get_episode(morph, content)
      job = MorphAutomaton.new(morph)
      job.auto
      episode_num = job.episode_num

      tfidf = get_tfidf(morph)
      return nil if tfidf.nil?

      return Episode.find_by(content_id: content.id, episode_num: episode_num)
    end

    def import_detail(path, content, episode)
      detail_url = 'http://tvanimedouga.blog93.fc2.com/' + path
      document = Common::UrlUtils.instance.get_document(detail_url)

      list = document.css('#mainBlock > div.mainEntryBlock > div.mainEntryBase > div.mainEntrykiji > a')
      list.each do |item|
        holder_name = item.inner_text.sub('【', '').sub('】', '')

        unless holder_name.index('検索')
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
