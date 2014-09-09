require 'open-uri'
require 'nokogiri'
require 'utils'
require 'chronic'

module Scrape
  class ScrapeForContents

    @doc_factory = nil
    @pager = 0
    def self.execute(year, season)
      @doc_factory = Utils::NokogiriDocumentFactory.new
      for i in 1..99 do
        document_for_anikore = @doc_factory.get_document_for_anikore(year, season, i)
        register_record_for_content(document_for_anikore, year, season)

        if @pager == i then
          break
        end
      end
    end

    def self.register_record_for_content(document_for_anikore, year, season)

      document_for_anikore.css('#main > div.paginator > span').each do |node|
        page = node.css('a.crpagebute').inner_text.to_i
        if page != "" then
          if @pager < page.to_i then
            @pager = page
          end
        end
      end

      document_for_anikore.xpath('//*[@id="main"]/div').each do |node|

        if node.css('div[1]/span[2]/a').inner_text != "" then
          content_id = node.css('div[1]/span[2]/a').attribute('href').value.split("/")[2].to_i

          content = Content.find_or_initialize_by(id: content_id)
          content.error = ''
=begin
          if content.title
            p "skip"
            next
          end
=end

          set_title(content, node)
          set_category_id(content, node)
          set_image(content, node)
          set_initial_by_detail_page(content)
          set_description_by_detail_page(content)
          set_trim_title(content)
          set_schedule_id(content, node, year, season)

          content.save
        end
      end
    end

    def self.set_title(content, node)
      title = node.css('div[1]/span[2]/a').inner_text

      if title.index('（テレビアニメ）')
        title.sub!("（テレビアニメ）","")
      elsif title.index('（アニメ映画）')
        title.sub!("（アニメ映画）","")
      elsif title.index('（OVA）')
        title.sub!("（OVA）","")
      elsif title.index('（Webアニメ）')
        title.sub!("（Webアニメ）","")
      elsif title.index('（OAD）')
        title.sub!("（OAD）","")
      elsif title.index('（その他）')
        title.sub!("（その他）","")
      else
        set_error(content, 'set_title:', title)
      end

      content.title = title
      return title
    end

    def self.set_category_id(content, node)
      title = node.css('div[1]/span[2]/a').inner_text
      category_id = nil

      if title.index("（テレビアニメ）")
        category_id = 1
      elsif title.index("（アニメ映画）")
        category_id = 2
      elsif title.index("（OVA）")
        category_id = 3
      elsif title.index("（Webアニメ）")
        category_id = 4
      elsif title.index("（OAD）")
        category_id = 5
      elsif title.index("（その他）")
        category_id = 90
      else
        category_id = 99
        set_error(content, 'set_category', title)
      end

      content.category_id = category_id
    end

    def self.set_image(content, node)
      url = nil
      begin
        url = node.css('div.animeImage > a > img').attribute('src').value
        url = url.slice(0, url.index('?'))
      rescue
        set_error(content, 'set_image', 'not exists the image.')
        return
      end
      if url == nil
        set_error(content, 'set_image', 'not exists the image url.')
        return
      end

      image = Image.find_or_initialize_by(table_name: 'contents', generic_id: content.id)
      if url == image.url
        # Already it is set the same url.
        return
      end

      begin
        image.url = url
        image.save
      rescue
        set_error(content, 'set_image', "can't save the image table.")
      end
    end

    def self.set_initial_by_detail_page(content)
      doc_by_detail = @doc_factory.get_document_for_anikore_by_detail(content.id)
      initial = doc_by_detail.css('#anime_intro_right > p.anime_intro_kana').inner_text.sub!('よみがな：','')

      if initial
        content.initial = initial
      else
        if content.initial
        else
          set_error(content, 'NotFoundよみがな', content.id.to_s + content.title)
        end
      end
    end

    def self.set_description_by_detail_page(content)
      doc_by_detail = @doc_factory.get_document_for_anikore_by_detail(content.id)
      description = doc_by_detail.css('#anime_intro > div.anime_title_intro_exp > blockquote').inner_text

      if description
        content.description = description
      else
        set_error(content, 'NotFoundDescription', content.id.to_s + content.title)
      end
    end

    def self.set_trim_title(content)
      content.trim_title = Utils.trim(content.title)
    end

    def self.set_schedule_id(content, node, year, season)
      schedule = get_schedule_by_anikore(content, node)
      if schedule == nil
        schedule = get_schedule_by_posite(content, year, season)
      end

      if schedule
        schedule = Schedule.find_or_initialize_by(schedule_code: "01", date: schedule, week: Utils.Weeks(schedule.wday))
        schedule.save
        content.schedule_id = schedule.id
      else
        if content.schedule_id && content.schedule_id != 90 && content.schedule_id != 99
        else
          content.schedule_id = Schedule.find_or_initialize_by(schedule_code: "99").id
          set_error(content, 'NotFoundScheduleDate', content.id.to_s + content.title)
        end
      end
    end

    def self.get_schedule_by_anikore(content, node)
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
        set_error(content, 'get_schedule_anikore', 'exception.' + date.to_s)
        return nil
      end
    end

    def self.get_schedule_by_posite(content, year, season)
      trim_title = content.trim_title

      doc = @doc_factory.get_document_for_posite(trim_title, year, season)

      array = []
      doc.css('.ani_e').each do |node|
        array << get_sorted_schedule(node, trim_title)
      end

      array = array.flatten
      array = array.compact
      array.delete("")

      if array.size == 0
        doc.css('.ani_o').each do |node|
          array << get_sorted_schedule(node, trim_title)
        end
      end

      array = array.flatten
      array = array.compact
      array.delete("")

      begin
        date_array = Array.new
        array.each do |str|
          date = Chronic.parse(str)
          if date
            date_array << date
          end
        end

        date_array.sort! do |a,b|
          a <=> b
        end
      rescue
        set_error(content, 'get_schedule_by_posite', trim_title + ',' + year + ',' + season + ' ' + array.to_s)
        return nil
      end

      return date_array.first
    end

    def self.get_sorted_schedule(node, trim_title)
      array = []

      text = node.css('td.title > a').inner_text
      text = Utils.trim(text)

      if text != "" && (text.index(trim_title) || trim_title.index(text))

        node.search('br').each do |word|
          word.replace('～')
        end

        node.css('td:last-child').each do |item|
          array << item.inner_text.split('～')
        end
      end

      return array
    end

    def self.set_error(entity, error_name, error_description)
      error = Error.find_or_initialize_by(name: error_name, description: error_description)
      error.save
    end
  end
end