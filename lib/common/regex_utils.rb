require 'open-uri'
require 'nokogiri'
require 'logger'
require 'net/http'
require 'uri'
require 'nkf'

module Common

  class RegexUtils
    # タイトル
    # 第n話
    # n
    # タイトル(Trim)
    # ※事前に不必要な文字を削除すること。
    #
    def self.get_episode_string(str)
      episode_num = get_episode_num(str)
      if episode_num == nil then
        return nil
      end

      /([第#]?[0]?#{episode_num}[話]?)/i =~ str
      episode_string = $1
      begin
        if episode_string
          episode_string = NKF::nkf( '-m0Z1 -w', episode_string )
        else
          return nil
        end
      rescue => e
        puts e.message
        raise 'It cannot get a episode string from ' + str + ' ' + episode_num + '.'
      else
        episode_string
      end
    end

    def self.get_episode_num(str)
      begin
        /[\s　]*第(?<episode_num>[0-9]{1,3}|[０１２３４５６７８９]{1,3})話/i =~ str

        if !episode_num then
          /[\s　]*([第#]{1})(?<episode_num>[0-9]{1,3}|[０１２３４５６７８９]{1,3})/i =~ str
        end

        if !episode_num then
          /[\s　]*(?<episode_num>[0-9]{1,3}|[０１２３４５６７８９]{1,3})([話])/i =~ str
        end
        
        if episode_num
          episode_num = NKF::nkf( '-m0Z1 -w', episode_num )
        else
          return nil
        end
      rescue
        raise 'It cannot get a episode number from ' + str + '.'
      else
        episode_num.to_i.to_s
      end
    end
    

    def self.get_title(str)
      str = String.new(str)
      episode_string = get_episode_string(str)
      if episode_string != nil then
        str.sub!(episode_string,'')
      end

      str.sub!('（最終回）', '')

      /(?<himawari> - ひまわり動画)/ =~ str
      if himawari then
        str.sub!(/ - ひまわり動画/, '')
        str.sub!(/(\S*高画質)/, '')
      end

      str = Utils.trim(str)

      sub_title = get_sub_title(str)
      if sub_title then
        str.sub!(sub_title, '')
        str.sub!('「」', '')
        str = Utils.trim(str)
      end
      return str
    end

    def self.get_title_trim(str)
      if str
        str.upcase!
        str = Utils.multi_trim(str)
      else
        nil
      end
    end

    def self.get_title_query(str)
      if str
        str.upcase!
        str = Utils.query_trim(str)
        p str
      else
        nil
      end
    end

    def self.get_title_regex(str)
      str = get_title(str)

      if str
        str.upcase!
        str = Utils.regex_trim(str)
      else
        nil
      end
    end

    def self.get_title_for_anikore(str)
      if str.index('（テレビアニメ）')
        str.sub!("（テレビアニメ）","")
      elsif str.index('（アニメ映画）')
        str.sub!("（アニメ映画）","")
      elsif str.index('（OVA）')
        str.sub!("（OVA）","")
      elsif str.index('（Webアニメ）')
        str.sub!("（Webアニメ）","")
      elsif str.index('（OAD）')
        str.sub!("（OAD）","")
      elsif str.index('（その他）')
        str.sub!("（その他）","")
      elsif str.index('（TVアニメ動画）')
        str.sub!("（TVアニメ動画）","")
      else
        StandardMailer.error_mail('RegexUtils', 'titleの取得に失敗しました。get_title_for_anikore関数を修正してください。' + str)
        return nil
      end
      
      while true
        /(?<remove>¥[.+?¥])/i =~ str
        
        if remove != nil
          str.gsub!(remove, '')
        else
          return str
        end
      end
    end

    def self.get_sub_title(str)
      /.*(?<=「)[\s　]?(?<sub_title>.*)(?=」)/ =~ str
      return sub_title
    end
  end
end
