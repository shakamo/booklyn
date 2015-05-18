require 'open-uri'
require 'nokogiri'
require 'chronic'

# Video
module Video
  # あにこれサイトからコンテンツ情報を取り込む。
  class Anikore
    include UrlUtils, TfIdf

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
    handle_asynchronously :import_page

    def import_images(url)
      doc = Nokogiri::HTML(get_body(url))

      # タイトルを繰り返す。
      doc.xpath('//*[@id="main"]/div').each do |title|
        content_id = doc.css('div[1]/span[2]/a').attribute('href').value.split('/')[2].to_i
        content = Content.find_or_initialize_by(id: content_id)

        if content.new_record?
          title = title.css('div[1]/span[2]/a').inner_text
          next if title.blank?
          tfidf = get_tfidf(title)
          next if tfidf.blank?
          content_id = tfidf['content_id'].to_i
        end

        save_image(content_id)
      end
    end
    handle_asynchronously :import_images

    def save_image(content_id)
      url = Settings.anikore.detail_url + content_id.to_s
      doc = Nokogiri::HTML(get_body(url))
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
    handle_asynchronously :save_image

    def get_max_page_size(year, season, type)
      url = Settings.anikore.url + path(year, season, type, '99')
      doc = Nokogiri::HTML(get_body(url))

      page_num = []
      doc.css('#main > div.paginator > span').each do |node|
        page_num << node.css('a.crpagebute').inner_text.to_i
      end

      page_num.max
    end

    def path(year, season, type, page)
      year.to_s + '/' + season.to_s + '/ac:' + type.to_s + '/page:' + page.to_s
    end

    # 使用しない
    def create_content(content_id, year, season, type)
      content = Content.find_or_initialize_by(id: content_id)
      content.error = ''

      url = Settings.anikore.detail_url + content_id.to_s
      doc = Nokogiri::HTML(get_body(url))

      set_title(content, doc)
      set_category(content, type)
      set_image(content, doc)
      set_initial(content, doc)
      set_description(content, doc)
      set_schedule(content, doc, year, season)

      content.save
    end

    # 使用しない
    def set_title(_content, doc)
      title = doc.css('div.animeDetailCommonHeadTitle.cb.cf.naturalFont > h2 > a').inner_text
      title.gsub!('」')
      title.gsub!('」')
    end

    # 使用しない
    def set_category(content, type)
      case type
      when :tv
        content.category_id = 1
      end
      return

      if title.index('（テレビアニメ）')
        content.category_id = 1
      elsif title.index('（TVアニメ動画）')
        content.category_id = 1
      elsif title.index('（アニメ映画）')
        content.category_id = 2
      elsif title.index('（OVA）')
        content.category_id = 3
      elsif title.index('（Webアニメ）')
        content.category_id = 4
      elsif title.index('（OAD）')
        content.category_id = 5
      elsif title.index('（その他）')
        content.category_id = 90
      else
      end
    end

    # 使用しない
    def set_initial(content, doc)
      initial = doc.css('p.animeDetailCommonHeadTitleKana').inner_text.sub!('よみがな：', '')
      if initial
        content.initial = initial
      else
        if content.initial
        else
          StandardMailer.error_mail('AnikoreContent', 'よみがなの取得に失敗しました。' + content.to_yaml).deliver
        end
      end
    end

    # 使用しない
    def set_description(content, doc)
      description = doc.css('blockquote').inner_text

      if description.present?
        content.description = description
      else
        StandardMailer.error_mail('AnikoreContent', 'Descriptionの取得に失敗しました。処理は中断しません。Content is ' + content.to_yaml).deliver
      end
    end

    # 使用しない
    def set_schedule(content, node, _year, _season)
      schedule = Video::ShoboiContent.get_schedule(content)

      if schedule.present?
        schedule = Schedule.find_or_initialize_by(schedule_code: '01', date: schedule, week: Common::Utils.Weeks(schedule.wday))
        schedule.save
        content.schedule_id = schedule.id
      else
        if content.schedule_id && content.schedule_id != 90 && content.schedule_id != 99
        else
          content.schedule_id = Schedule.find_or_initialize_by(schedule_code: '99').id
          StandardMailer.error_mail('AnikoreContent', 'Scheduleの取得に失敗しました。ただし、処理は中断されません。 content id is' + content.id.to_s + '. title is' + content.title + '. Anikore is ' + node.css('div.animeChronicle > span > a').inner_text).deliver
        end
      end
    end
  end
end
