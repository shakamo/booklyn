require 'active_support/concern'
require 'open-uri'
require 'nokogiri'
require 'chronic'
require 'url_utils'
require 'date'

module Video
  # Shoboiサイトから、Content、Episode、Scheduleを取得する。
  class Shoboi
    include UrlUtils, DateUtils

    def initialize
      Time.zone = 'Asia/Tokyo'
      Chronic.time_class = Time.zone
    end

    def import_all
      docs = Nokogiri::XML(get_body(Settings.shoboi.title))
      docs.css(:TitleItem).each do |doc|
        content = get_content(doc)

        episodes = doc.css(:SubTitles).text
        save_episodes(content.id, episodes)
      end
    end

    def get_content(doc)
      tid = doc.css(:TID).text.to_i
      title = doc.css(:Title).text
      count = doc.css(:Cat).text
      yomi = doc.css(:TitleYomi).text
      comment = doc.css(:Title).text

      content = Content.find_or_initialize_by(tid: tid)
      content.title = title
      content.initial = yomi
      content.description = comment
      content.category_id = get_category(doc, count)
      content.schedule_id = get_schedule(tid).id
      content.save

      content
    end

    def get_schedule(tid)
      docs = Nokogiri::XML(get_body(Settings.shoboi.schedule + tid.to_s))
      if docs.css(:ProgItem).size == 0
        return Schedule.find_or_initialize_by(schedule_code: '99')
      end

      time = nil
      docs.css(:ProgItem).each do |doc|
        time = [Chronic.parse(doc.css(:StTime).text), time].compact.min
      end

      return Schedule.find_or_initialize_by(id: 99) if time.nil?

      # Timeから5時間分引いた日付を取得する。
      date = (time - 18_000).to_date
      schedule = Schedule.find_or_initialize_by(date: date, schedule_code: '01')
      schedule.schedule_code = '01'
      schedule.schedule_name = get_week_name(date.wday)
      schedule.week = get_week(date.wday)
      schedule.date = date
      schedule.save

      schedule
    end

    def save_episodes(content_id, sub_title_string)
      sub_titles = get_episodes(sub_title_string)
      sub_titles.each_with_index do |item, index|
        next if index.odd?
        episode = Episode.find_or_initialize_by(content_id: content_id, episode_num: item.to_i)
        episode.episode_name = sub_titles[index + 1]
        episode.save
      end
    end
    handle_asynchronously :save_episodes

    def get_episodes(subTitles)
      subTitles = subTitles.split(/[*]([0-9]{3})[*]/)
      return subTitles.drop(1)
    end

    # 利用していない。
    def search_path(title)
      url = URI.encode(Settings.shoboi.search + title + '&ch=&st=&cm=&r=0&rd=&v=0')
      result_search = Nokogiri::HTML(get_body(url), nil)
      result = result_search.css('#main > table > tr > td > table.tframe > tr > td > a')
      result[0][:href] if result.present? && 1 <= result.size
    end

    # 1 アニメ
    # 10 アニメ(終了/再放送)
    # 7 OVA
    # 5 アニメ関連
    # 4 特撮
    # 8 映画
    # 3 テレビ
    # 2 ラジオ
    # 6 メモ
    # 0 その他
    def get_category(doc, code)
      case code
      when '1'
        return '01'
      when '10'
        return '01'
      when '7'
        return '03'
      when '8'
        return '02'
      when '4'
        return '10'
      else
        error = Error.new
        error.description = doc.text
        error.save
      end
    end
  end
end
