require 'open-uri'
require 'nokogiri'
require 'common/utils'
require 'chronic'

module Scrape
  class PositeContent

    def self.get_schedule(content, year, season)
      doc = Common::UrlUtils.instance.get_document_for_posite(year, season)

      regex_title = Common::RegexUtils.get_title_regex(content.title)

      array = []
      doc.css('.ani_e').each do |node|
        array << get_sorted_schedule(node, regex_title)
      end

      array = array.flatten
      array = array.compact
      array.delete("")

      if array.size == 0
        doc.css('.ani_o').each do |node|
          array << get_sorted_schedule(node, regex_title)
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
        return nil
      end

      return date_array.first
    end

    def self.get_sorted_schedule(node, regex_title)
      array = []

      posite_title = node.css('td.title > a').inner_text
      /#{regex_title}/ =~ posite_title

      if posite_title != "" && $1 != nil

        node.search('br').each do |word|
          word.replace('～')
        end

        node.css('td:last-child').each do |item|
          array << item.inner_text.split('～')
        end
      end

      return array
    end
  end
end