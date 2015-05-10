require 'open-uri'
require 'nokogiri'
require 'chronic'

module Video
  # あにこれサイトからコンテンツ情報を取り込む。
  class Anikore
    include UrlUtils, NokogiriUtils
    ANIKORE_URI = 'http://www.anikore.jp/chronicle/'
    ANIKORE_DETAIL_URI = 'http://www.anikore.jp/anime/'

    def import_all(year, season)
      import(year, season, 'ac:tv')
      import(year, season, 'ac:movie')
    end

    def import(year, season, type)
      max_page_size = get_max_page_size(year, season, type)

      1..max_page_size.each do |page|
        url = ANIKORE_URI + path(year, season, type, page)
        import_page(url, year, season)

        break if @max_page == page
      end
    end
    handle_asynchronously :import

    def get_max_page_size(year, season, type)
      url = ANIKORE_URI + path(year, season, type, '99')
      doc = html(get_body(url))

      page_num = []
      doc.css('#main > div.paginator > span').each do |node|
        page_num << node.css('a.crpagebute').inner_text.to_i
      end

      page_num.max
    end

    def get_detail(content_id)
      url = ANIKORE_DETAIL_URI + content_id.to_s
      doc = html(get_body(url))
    end

    def path(year, season, type, page)
      year.to_s + '/' + season.to_s + '/' + type + '/page:' + page.to_s
    end
  end
end
