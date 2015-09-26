require 'open-uri'
require 'nokogiri'
require 'chronic'
require 'uri'
require 'dalli'

module Video
  #
  class PostManager
    def self.register_post(holder_name, url, trim_title, episode_num)
      holder = nil
      case holder_name
      when 'ひまわり'
        holder = Video::Himawari.new
      when 'Himawari'
        holder = Video::Himawari.new
      when 'himawari'
        holder = Video::Himawari.new
      when 'B9'
        holder = Video::B9dm.new
      when 'B9DM'
        holder = Video::B9dm.new
      when 'NoSub'
        holder = Video::Nosub.new
      when 'Nosub'
        holder = Video::Nosub.new
      when 'nosub'
        holder = Video::Nosub.new
      when 'Ｖｅｏｈ'
        holder = Video::Veoh.new
      when 'Veoh'
        holder = Video::Veoh.new
      when 'SayMove'
        holder = Video::Saymove.new
      when 'Saymove'
        holder = Video::Saymove.new
      when 'saymove'
        holder = Video::Saymove.new
      when 'Dailymotion'
        holder = Video::Dailymotion.new
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
