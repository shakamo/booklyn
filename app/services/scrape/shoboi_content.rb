require 'open-uri'
require 'nokogiri'
require 'common/utils'
require 'chronic'

module Scrape
  class ShoboiContent
    def self.get_schedule(content)
      doc = Common::UrlUtils.instance.get_document_for_shoboi(content, 'time')
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

    def self.get_episode_name(content, episode)
      doc = Common::UrlUtils.instance.get_document_for_shoboi(content, 'subtitle')
      subtitles = doc.css('#tid_subtitle > table > tbody > tr')

      subtitles.each do |subtitle|
        if subtitle.css('td')[0].inner_text.to_i == episode.episode_num then
          return subtitle.css('td')[1].inner_text
        end
      end

      return nil
    end
  end
end
