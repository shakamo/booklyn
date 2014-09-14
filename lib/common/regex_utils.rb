require 'open-uri'
require 'nokogiri'
require 'logger'
require 'net/http'
require 'uri'

module Common
  class RegexUtils
    def self.get_episode_num(str)
      begin
        /[\s　]+([第]?(?<episode_num>[0-9]{1,3})話)/i =~ str

        Integer(episode_num)
      rescue
        raise 'It cannot get a episode number from ' + str + '.'
      else
        episode_num
      end
    end

    def self.get_trim_title(str)
      begin

        /[\s　]+(?<episode_num>[第]?[0-9]{1,3}話)/i =~ str
        str.sub!(episode_num,'')
        str.upcase!
        str = Utils.trim(str)
      rescue
        rise 'It cannot get a title from ' + str
      else
        str
      end
    end

    def self.get_sub_title(str)
      begin
        /話「(?<sub_title>.*)」/ =~ str
      rescue
        raise 'It cannot get a sub-title from ' + str
      else
        sub_title
      end
    end
  end
end
