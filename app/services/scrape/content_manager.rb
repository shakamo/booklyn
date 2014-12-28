module Scrape
  class ContentManager

    def self.createAll(site_name, year)
      if site_name == 'Anikore' then
        AnikoreContent.createAll(year)
      end
    end

    def self.createAll(site_name, year, season)
      if site_name == 'Anikore' then
        AnikoreContent.createAll(year, season)
      end
    end

    def self.get_content(title_query)
      contents = Content.where(Content.arel_table[:trim_title].matches(title_query))

      if contents && contents.size == 1
        return contents.first
      end

      contents = Content.where((Content.arel_table[:trim_title].matches(title_query + '%').
      or(Content.arel_table[:trim_title].matches('%' + title_query).
      or(Content.arel_table[:trim_title].matches('%' + title_query + '%')))))

      if contents && contents.size == 1
        return contents.first
      else
        StandardMailer.error_mail('ContentManager', 'Content データが取得できませんでした。対象データはスキップされます。' + title_query).deliver
        return nil
      end
    end
  end
end
