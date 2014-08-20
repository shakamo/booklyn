require 'open-uri'
require 'nokogiri'
require 'utils'

module Scrape
  class Scraping

    @doc_factory = nil
    @pager = 0
    def self.execute(year, season)
      @doc_factory = Utils::NokogiriDocumentFactory.new

      for i in 1..99 do
        document_for_anikore = @doc_factory.get_document_for_anikore(year, season, i)
        create_record_for_content(document_for_anikore, year, season)

        if @pager == i then
          break

        end

      end
    end

    def self.create_record_for_content(document_for_anikore, year, season)

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

          title = node.css('div[1]/span[2]/a').inner_text

          if title.sub!("（テレビアニメ）","") then
            category_id = 1
          end
          if title.sub!("（アニメ映画）","") then
            category_id = 2
          end
          if title.sub!("（OVA）","") then
            category_id = 3
          end
          if title.sub!("（Webアニメ）","") then
            category_id = 4
          end
          if title.sub!("（その他）","") then
            category_id = 90
          end

          content_id = node.css('div[1]/span[2]/a').attribute('href').value.split("/")[2].to_i
          image = node.css('div.animeImage > a > img').attribute('src').value
          image = image.slice(0, image.index('?'))

          initial = get_initial_by_detail_page(content_id)
          description = get_description_by_detail_page(content_id)

          schedule = get_schedule_by_posite(title, year, season)

          content = Content.find_or_initialize_by(id: content_id)
          content.category_id = category_id
          content.title = title
          content.initial = initial
          content.description = description

          p content
        end
      end
    end

    def self.get_initial_by_detail_page(content_id)
      doc_by_detail = @doc_factory.get_document_for_anikore_by_detail(content_id)
      return doc_by_detail.css('#anime_intro_right > p.anime_intro_kana').inner_text.sub!('よみがな：','')
    end

    def self.get_description_by_detail_page(content_id)
      doc_by_detail = @doc_factory.get_document_for_anikore_by_detail(content_id)
      return doc_by_detail.css('#anime_intro > div.anime_title_intro_exp > blockquote').inner_text
    end

    def self.get_schedule_by_posite(title, year, season)
      doc = @doc_factory.get_document_for_posite(title, year, season)
      doc.css('.ani_e').each do |node|
        text = node.css('td.title > a').inner_text
        if text.index(title)
          
          node.search('br').each do |word|
            word.replace('')
          end
          
          array = []
          node.css('td:last-child').each do |item|
            array.concat(item.inner_text.split('～'))
          end
          
          array = array.sort do |a,b|
            a <=> b
          end
          
          return ""
        end
      end
      doc.css('.ani_o').each do |node|
        text = node.css('td.title > a').inner_text
        if text.index(title)
          date = node.css('td:last-child').inner_text
          date = date.sub("?","").split(" ")
          return ""
        end
      end
    end
  end
end