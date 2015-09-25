require 'open-uri'
require 'nokogiri'
require 'chronic'
require 'uri'
require 'nokogiri'

module Video
  #
  class Tvanimedouga
    include GooLabs, TfIdf

    def initialize
      Time.zone = 'Asia/Tokyo'
      Chronic.time_class = Time.zone
    end

    def import_all
      for num in 1..30 do
        import_page(num)
      end
    end

    def import_page(num = 1)
      get_list(num).each do |item|
        morph = call_morph(item[:title])

        content = get_content(morph)
        next if content.nil?

        episode = get_episode(morph, content)
        next if episode.nil?

        import_detail(item[:path], content, episode)
      end
    end
    handle_asynchronously :import_page, queue: :tvanimedouga

    def get_list(num = 1)
      url = Settings.tvanimedouga.url + num.to_s
      list = []

      docs = get_body(url)

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
      if tfidf.nil?
        Error.create description: morph[:raw].to_s
        return nil
      end

      Content.find_by id: tfidf['content_id']
    end

    def get_episode(morph, content)
      job = MorphAutomaton.new(morph)
      job.auto
      episode_num = job.episode_num

      if episode_num.nil?
        Error.create description: morph[:raw].to_s
        return nil
      end

      Episode.find_by(content_id: content.id, episode_num: episode_num)
    end

    def import_detail(path, content, episode)
      url = 'http://tvanimedouga.blog93.fc2.com/' + path
      doc = get_body(url)

      list = doc.css('#mainBlock > div.mainEntryBlock > div.mainEntryBase > div.mainEntrykiji > a')
      list.each do |item|
        holder_name = item.inner_text.sub('【', '').sub('】', '')

        next if holder_name.index('検索')

        url = URI.escape(item.attribute('href').value)

        next if url.index('http://himado.in/?sort=&')
        next if url.index('http://himado.in/?keyword=')
        next if url.index('http://www.nosub.tv/?s=%')
        next if url.index('http://www.veoh.com/find/?query')

        Video::PostManager.register_post(holder_name, url, content, episode)
      end
    end

    def error_test
      Error.new description: 'test'
    end
  end
end
