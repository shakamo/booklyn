require 'open-uri'
require 'nokogiri'
require 'chronic'
require 'uri'

module Scrape::Holders
  class ScrapeForPosts
    @@Contents = %w(ひまわり B9 Saymove anitube NoSub Videofan Ｖｅｏｈ)
    def self.register_post(holder_name, url, trim_title, episode_num)
      holder = nil
      case holder_name
      when 'ひまわり'
        holder = Himawari.new
      when 'Himawari'
        holder = Himawari.new
      when 'himawari'
        holder = Himawari.new
      when 'B9'
        holder = B9dm.new
      when 'B9DM'
        holder = B9dm.new
      when 'NoSub'
        holder = Nosub.new
      when 'Nosub'
        holder = Nosub.new
      when 'nosub'
        holder = Nosub.new
      when 'Ｖｅｏｈ'
        holder = Veoh.new
      when 'Veoh'
        holder = Veoh.new
      when 'SayMove'
        holder = Saymove.new
      when 'Saymove'
        holder = Saymove.new
      when 'saymove'
        holder = Saymove.new
      when 'Dailymotion'
        holder = Dailymotion.new
      else
        if holder_name.index('検索')
        elsif holder_name.index('動画一覧')
        else
          p 'unknown ' + holder_name + ' ' + url
        end
      end

      if holder
        holder.execute(url, trim_title, episode_num)
      end
    end
  end
end