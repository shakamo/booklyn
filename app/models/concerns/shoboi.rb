require 'active_support/concern'
require 'open-uri'
require 'nokogiri'
require 'chronic'
require 'url_utils'

module Shoboi
  extend ActiveSupport::Concern
  include UrlUtils

  SHOBOI_URL = 'http://cal.syoboi.jp'
  SHOBOI_SEARCH_URL = 'http://cal.syoboi.jp/find?sd=0&kw='
  SHOBOI_DB_TITLE = 'http://cal.syoboi.jp/db.php?Command=TitleLookup&TID=1,2'
  SHOBOI_DB_SCHEDULE = 'http://cal.syoboi.jp/db.php?Command=TitleLookup&TID=1,2'

  def import_all
    docs = Nokogiri::XML(get_body(SHOBOI_DB))

    new_records = []

    docs.css(:TitleItem).each do |doc|
      content = Content.find_or_initialize_by(tid: doc.css(:tid).text)
      content.title = doc.css(:title).text
      content.initial = doc.css(:titleyomi).text
      content.description = doc.css(:comment).text
      content.category_id = get_category(doc.css(:cat).text)


      if content.new_record?
        new_records << content
      else
        content.save
      end
    end
    Content.import new_records
  end

  def get_schedule(title, type = :time)
    # Search url-path
    path = search_path(title)
    return if path.nil?

    # Get Information
    url = SHOBOI_URL + path + '/' + type.to_s
    doc = Nokogiri::HTML(get_body(url))

    begin
      date = doc.css('td.start > a')[0][:href].sub('/?date=', '')
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

  def get_episode_name(content, episode)
    doc = Nokogiri::HTML(get_body(content, 'subtitle'))
    subtitles = doc.css('#tid_subtitle > table > tbody > tr')

    subtitles.each do |subtitle|
      if subtitle.css('td')[0].inner_text.to_i == episode.episode_num
        return subtitle.css('td')[1].inner_text
      end
    end
    nil
  end

  def search_path(title)
    url = URI.encode(SHOBOI_SEARCH_URL + title + '&ch=&st=&cm=&r=0&rd=&v=0')
    result_search = Nokogiri::HTML(get_body(url), nil)
    result = result_search.css('#main > table > tr > td > table.tframe > tr > td > a')
    result[0][:href] if result.present? && 1 <= result.size
  end

  def get_category(code)
    case code
    when '1'
      return 1
    when '10'
      return 1
    when '7'
      return 3
    when '8'
      return 2
    else
      fail code
    end
  end

  def get_schedule(tid)

  end
end
