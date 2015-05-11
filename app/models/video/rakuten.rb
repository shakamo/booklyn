require 'open-uri'
require 'nokogiri'
require 'chronic'

module Video
  class Rakuten
    def self.create(season)
      url = 'http://entertainment.rakuten.co.jp/drama/special/' + season + '_drama/'
      document = get_body(url)

      if document.nil?
        StandardMailer.error_mail('RakutenContent', 'データの取得に失敗しました。url:' + url).deliver
        fail 'RakutenContent データの取得に失敗しました。url:' + url
      end

      load_list(document, url)
    end

    def self.load_list(document, url)
      week_name = document.css('#dramaIndex > .heading > h2')
      dorama_list = document.css('#dramaIndex > .listWrap')

      for i in 1..week_name.size do
        load_page(dorama_list[i - 1], url, week_name[i - 1].inner_text)
      end
    end

    def self.load_page(document, url, week_name)
      # タイトルを繰り返す。
      title_list = document.css('.frame')
      if title_list.size == 0
        # タイトルを取得できない場合、エラーメール送信。
        StandardMailer.error_mail('RakutenContent', 'データの取得に失敗しました。').deliver
        fail 'RakutenContent データの取得に失敗しました。'
      end

      title_list.each do |node|
        content_id = node.css('.ttl > a')
        if content_id.nil?
          StandardMailer.error_mail('RakutenContent', 'データの取得に失敗しました。').deliver
          fail 'RakutenContent データの取得に失敗しました。'
        end
        content_id = content_id[0][:href].sub('/', '').to_i

        content = Content.find_or_initialize_by(id: content_id)
        content.error = ''

        set_title(content, node)
        set_category(content, node)
        set_image(content, node, url)
        set_initial_by_detail_page(content)
        set_description_by_detail_page(content, url)
        set_trim_title(content)
        set_schedule(content, week_name)

        content.save
      end
    end

    def self.set_title(content, node)
      title = node.css('.ttl > a').inner_text
      content.title = title
    end

    def self.set_category(content, _node)
      # ドラマを設定
      content.category_id = 11
    end

    def self.set_image(content, node, base_url)
      url = nil
      begin
        url = base_url + node.css('img').attribute('src').value
        url = url.sub('/index', '')
      rescue
        StandardMailer.error_mail('RakutenContent', '画像が存在しませんでした。' + content.to_yaml).deliver
        raise 'RakutenContent Anikore'
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
        StandardMailer.error_mail('RakutenContent', '画像が存在しませんでした。' + content.to_yaml).deliver
        raise 'RakutenContent Anikore'
      end
    end

    def self.set_initial_by_detail_page(content)
      if content.initial
      else
        StandardMailer.error_mail('RakutenContent', 'よみがなを設定してください。' + content.to_yaml).deliver
      end
    end

    def self.set_description_by_detail_page(content, base_url)
      doc_detail = Common::UrlUtils.instance.get_document(base_url + content.id.to_s.rjust(8, '0'))
      description = doc_detail.css('div.article').inner_text

      if !description.nil? && description != ''
        content.description = description
      else
        StandardMailer.error_mail('RakutenContent', 'Descriptionの取得に失敗しました。処理は中断しません。Content is ' + content.to_yaml).deliver
      end
    end

    def self.set_trim_title(content)
      trim_title = Common::RegexUtils.get_title_trim(content.title)

      if content.trim_title.nil?
        content.trim_title = trim_title
      elsif !content.trim_title.include?(trim_title)
        content.trim_title += trim_title
      end
    end

    def self.set_schedule(content, week_name)
      if '朝・昼' == week_name
        schedule = Schedule.find_or_initialize_by(schedule_code: '80')
        content.schedule_id = schedule.id
      elsif '日曜日' == week_name
        schedule = Schedule.find_or_initialize_by(schedule_code: '81')
        content.schedule_id = schedule.id
      elsif '月曜日' == week_name
        schedule = Schedule.find_or_initialize_by(schedule_code: '82')
        content.schedule_id = schedule.id
      elsif '火曜日' == week_name
        schedule = Schedule.find_or_initialize_by(schedule_code: '83')
        content.schedule_id = schedule.id
      elsif '水曜日' == week_name
        schedule = Schedule.find_or_initialize_by(schedule_code: '84')
        content.schedule_id = schedule.id
      elsif '木曜日' == week_name
        schedule = Schedule.find_or_initialize_by(schedule_code: '85')
        content.schedule_id = schedule.id
      elsif '金曜日' == week_name
        schedule = Schedule.find_or_initialize_by(schedule_code: '86')
        content.schedule_id = schedule.id
      elsif '土曜日' == week_name
        schedule = Schedule.find_or_initialize_by(schedule_code: '87')
        content.schedule_id = schedule.id
      end
    end
  end
end
