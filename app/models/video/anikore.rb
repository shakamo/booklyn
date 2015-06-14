require 'open-uri'
require 'nokogiri'
require 'chronic'

# Video
module Video
  # あにこれサイトからコンテンツ情報を取り込む。
  class Anikore
    include UrlUtils, TfIdf, GooLabs

    def import_tv(year, season)
      import_page(year, season, :tv)
    end

    def import_movie(year, season)
      import_page(year, season, :movie)
    end

    def import_page(year, season, type)
      max_page_size = get_max_page_size(year, season, type)

      1..max_page_size.each do |page|
        url = Settings.anikore.url + path(year, season, type, page)
        import_images(url)

        break if @max_page == page
      end
    end
    handle_asynchronously :import_page, queue: :anikore_import_page

    def import_images(url)
      docs = get_body(url)

      # タイトルを繰り返す。
      docs.xpath('//*[@id="main"]/div/div/span[2]').each do |doc|
        ak_id = doc.xpath('a').attribute('href').value.split('/')[2].to_i
        content = Content.find_by(akid: ak_id)

        if content.nil?
          title = doc.css('a').inner_text
          puts title
          next if title.blank?
          morph = call_morph(title)
          tfidf = get_tfidf(morph)
          next if tfidf.blank?
          content_id = tfidf['content_id'].to_i
        elsif
          content_id = content.id
        end

puts ak_id.to_s + content_id.to_s
        save_image(ak_id, content_id)
      end
    end
    handle_asynchronously :import_images, queue: :anikore_import_images

    def save_image(ak_id, content_id)
      puts ak_id.to_s + content_id.to_s
      url = Settings.anikore.detail_url + ak_id.to_s
      doc = get_body(url)
      url = nil
      begin
        url = node.css('#sub > div.animeDetailSubImage > img').attribute('src').value
        url = url.slice(0, url.index('?'))
      rescue
        StandardMailer.error_mail('AnikoreContent', '画像が存在しませんでした。 content id is' + content_id.to_s + '.').deliver
        raise 'AnikoreImageが取得できません。' + content_id.to_s + '.'
      end

      if url.nil?
        StandardMailer.error_mail('AnikoreContent', '画像が取得できませんでした。url is null. content id is' + content_id.to_s + '.').deliver
        fail 'AnikorImageのURLがnilです。' + content_id.to_s + '.'
      end

      image = Image.find_or_initialize_by(table_name: 'contents', generic_id: content_id.to_s)
      if url == image.url
        # Already it is set the same url.
        return
      end

      begin
        image.url = url
        image.save
      rescue
        StandardMailer.error_mail('AnikoreContent', '画像URLの保存に失敗しました。url is ' + url + '. content id is' + content_id.to_s + '.').deliver
        raise content, 'AnikoreContent Anikore set_image cant save the image table.'
      end
    end

    def get_max_page_size(year, season, type)
      url = Settings.anikore.url + path(year, season, type, '99')
      doc = get_body(url)

      page_num = []
      doc.css('#main > div.paginator > span').each do |node|
        page_num << node.css('a.crpagebute').inner_text.to_i
      end

      page_num.max
    end

    def path(year, season, type, page)
      year.to_s + '/' + season.to_s + '/ac:' + type.to_s + '/page:' + page.to_s
    end
  end
end
