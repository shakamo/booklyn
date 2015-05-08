require 'open-uri'
require 'nokogiri'
require 'chronic'
require 'uri'
require 'dalli'

module Scrape::Post
  class PostManager
    @@Contents = %w(ひまわり B9 Saymove anitube NoSub Videofan Ｖｅｏｈ)
    def self.register_post(holder_name, url, trim_title, episode_num)
      holder = nil
      case holder_name
      when 'ひまわり'
        holder = Holders::Himawari.new
      when 'Himawari'
        holder = Holders::Himawari.new
      when 'himawari'
        holder = Holders::Himawari.new
      when 'B9'
        holder = Holders::B9dm.new
      when 'B9DM'
        holder = Holders::B9dm.new
      when 'NoSub'
        holder = Holders::Nosub.new
      when 'Nosub'
        holder = Holders::Nosub.new
      when 'nosub'
        holder = Holders::Nosub.new
      when 'Ｖｅｏｈ'
        holder = Holders::Veoh.new
      when 'Veoh'
        holder = Holders::Veoh.new
      when 'SayMove'
        holder = Holders::Saymove.new
      when 'Saymove'
        holder = Holders::Saymove.new
      when 'saymove'
        holder = Holders::Saymove.new
      when 'Dailymotion'
        holder = Holders::Dailymotion.new
      else
        if holder_name.index('検索')
        elsif holder_name.index('動画一覧')
        else
          p 'unknown ' + holder_name + ' ' + url
        end
      end

      if holder
        holder.execute(url, trim_title, episode_num)

        if ENV['MEMCACHEDCLOUD_SERVERS']
          $cache = Dalli::Client.new(ENV['MEMCACHEDCLOUD_SERVERS'].split(','), username: ENV['MEMCACHEDCLOUD_USERNAME'], password: ENV['MEMCACHEDCLOUD_PASSWORD'])

          path = 'http://video.booklyn.info/?_escaped_fragment_='
          $cache.set(path, nil)

          path = 'http://video.booklyn.info/episode/8037'
          $cache.set(path, nil)

        end
      end
    end
  end
end
