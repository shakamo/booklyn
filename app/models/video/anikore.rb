require 'open-uri'
require 'nokogiri'
require 'chronic'

class Video::Anikore
  include UrlUtils, GooLabs, RegexUtils

  @max_page = 0

  def import_all(year, season)
    import(year, season, 'ac:tv')
    import(year, season, 'ac:movie')
  end
  
  def import(year, season, type)
    @max_page = 0

    for page in 1..99 do
      url = 'http://www.anikore.jp/chronicle/' + year.to_s + '/' + season.to_s + '/' + type + '/page:' + page.to_s

      import_page(url, year, season)

      if @max_page == page then
        break
      end
    end
  end
  handle_asynchronously :import

  def import_page(url, year, season)
    document = get_document(url)

    if document == nil then
      StandardMailer.append_error_text('AnikoreContent', 'データの取得に失敗しました。url:' + url).deliver
      raise 'AnikoreContent データの取得に失敗しました。url:' + url
    end

    # Maxページ数を取得する。
    document.css('#main > div.paginator > span').each do |node|
      page = node.css('a.crpagebute').inner_text.to_i
      if page != "" then
        if @max_page < page.to_i then
          @max_page = page
        end
      end
    end

    # タイトルを繰り返す。
    title_list = document.xpath('//*[@id="main"]/div')
    if 0 == title_list.size then
      # タイトルを取得できない場合、エラーメール送信。
      StandardMailer.error_mail('AnikoreContent', 'Anikore ' + year + ' ' + season + ' ' + '0件<br>データが取得できませんでした。').deliver
      raise 'AnikoreContent Anikore ' + year + ' ' + season + ' ' + '0件 データが取得できませんでした。'
    end

    document.xpath('//*[@id="main"]/div').each do |node|

      if node.css('div[1]/span[2]/a').inner_text != "" then
        content_id = node.css('div[1]/span[2]/a').attribute('href').value.split("/")[2].to_i
        if content_id == nil then
          StandardMailer.error_mail('AnikoreContent', 'Anikore ' + year + ' ' + season + ' ' + 'ContentIdが取得できません。フォーマットが変更された可能性があります。').deliver
          raise 'AnikoreContent Anikore ' + year + ' ' + season + ' ' + 'ContentIdが取得できません。'
        end

        content = Content.find_or_initialize_by(id: content_id)
        content.error = ''

        set_title(content, node)
        set_category(content, node)
        set_image(content, node)
        set_initial_by_detail_page(content)
        set_description_by_detail_page(content)
        set_trim_title(content)
        set_schedule(content, node, year, season)

        content.save
      end
    end
  end

  def set_title(content, node)
    title = node.css('div[1]/span[2]/a').inner_text
    content.title = get_title_for_anikore(title)
  end

  def set_category(content, node)
    title = node.css('div[1]/span[2]/a').inner_text

    if title.index("（テレビアニメ）")
      content.category_id = 1
    elsif title.index("（TVアニメ動画）")
      content.category_id = 1
    elsif title.index("（アニメ映画）")
      content.category_id = 2
    elsif title.index("（OVA）")
      content.category_id = 3
    elsif title.index("（Webアニメ）")
      content.category_id = 4
    elsif title.index("（OAD）")
      content.category_id = 5
    elsif title.index("（その他）")
      content.category_id = 90
    else
      if content.category_id == nil then
        StandardMailer.error_mail('AnikoreContent', 'categoryが取得できません。' + title).deliver
        raise 'AnikoreContent Anikore Categoryが取得できません。' + title
      end
    end
  end

  def set_image(content, node)
    url = nil
    begin
      url = node.css('div.animeImage > a > img').attribute('src').value
      url = url.slice(0, url.index('?'))
    rescue
      StandardMailer.error_mail('AnikoreContent', '画像が存在しませんでした。 content id is' + content.id.to_s + '. title is' + content.title + '.').deliver
      raise 'AnikoreContent Anikore ' + year + ' ' + season + ' ' + 'Imageが取得できません。' + content.id.to_s + '. title is' + content.title + '.'
    end

    if url == nil
      StandardMailer.error_mail('AnikoreContent', '画像が取得できませんでした。url is null. content id is' + content.id.to_s + '. title is' + content.title + '.').deliver
      raise 'AnikoreContent Anikore ' + year + ' ' + season + ' ' + 'ImageのURLがnilです。' + content.id.to_s + '. title is' + content.title + '.'
    end

    image = Image.find_or_initialize_by(table_name: 'contents', generic_id: content.id.to_s)
    if url == image.url
      # Already it is set the same url.
      return
    end

    begin
      image.url = url
      image.save
    rescue
      StandardMailer.error_mail('AnikoreContent', '画像URLの保存に失敗しました。url is ' + url + '. content id is' + content.id.to_s + '. title is' + content.title + '.').deliver
      raise content, 'AnikoreContent Anikore set_image cant save the image table.'
    end
  end

  def set_initial_by_detail_page(content)
    doc_by_detail = get_document_for_anikore_by_detail(content.id.to_s)
    initial = doc_by_detail.css('.animeDetailCommonHeadTitleKana').inner_text.sub!('よみがな：','')
    if initial
      content.initial = initial
    else
      if content.initial
      else
        StandardMailer.error_mail('AnikoreContent', 'よみがなの取得に失敗しました。' + content.to_yaml).deliver
      end
    end
  end

  def set_description_by_detail_page(content)
    doc_by_detail = get_document_for_anikore_by_detail(content.id.to_s)
    description = doc_by_detail.css('.animeDetailTopIntroduceBody--story > blockquote').inner_text

    if description != nil && description != ""
      content.description = description
    else
      StandardMailer.error_mail('AnikoreContent', 'Descriptionの取得に失敗しました。処理は中断しません。Content is ' + content.to_yaml).deliver
    end
  end

  def set_trim_title(content)
    morph = call_morph(content.title)

    puts morph

    trim_title = get_title_trim(content.title)

    if content.trim_title == nil then
      content.trim_title = trim_title
    elsif !content.trim_title.include?(trim_title) then
      content.trim_title += trim_title
    end
  end

  def set_schedule(content, node, year, season)
    schedule = get_schedule(content, node)
    if schedule == nil
      schedule = Scrape::ShoboiContent.get_schedule(content)
      if schedule == nil
        schedule = Scrape::PositeContent.get_schedule(content, year, season)
      end
    end

    if schedule
      schedule = Schedule.find_or_initialize_by(schedule_code: "01", date: schedule, week: Common::Utils.Weeks(schedule.wday))
      schedule.save
      content.schedule_id = schedule.id
    else
      if content.schedule_id && content.schedule_id != 90 && content.schedule_id != 99
      else
        content.schedule_id = Schedule.find_or_initialize_by(schedule_code: "99").id
        StandardMailer.error_mail('AnikoreContent', 'Scheduleの取得に失敗しました。ただし、処理は中断されません。 content id is' + content.id.to_s + '. title is' + content.title + '. Anikore is ' + node.css("div.animeChronicle > span > a").inner_text).deliver
      end
    end
  end

  def get_schedule(content, node)
    begin
      date = node.css("div.animeChronicle > span > a").inner_text
      date.sub!("年","/")
      date.sub!("月","/")
      date.sub!("日","")
      parse_date = Chronic.parse(date)
      if parse_date
        return parse_date
      else
        return nil
      end
    rescue
      return nil
    end
  end
end
