require 'open-uri'
require 'nokogiri'
require 'chronic'
require 'uri'

module Video
  class Himawari
    include Holder, UrlUtils
    def execute(url, _content, episode)
      holder_name = 'ひまわり動画'

      doc = get_body(url)

      platform_name = 'All'
      post = create_post(url, episode, holder_name, platform_name)

      if doc.nil?
        post.available = 'NG'
        post.error = 'ResponseCode is 4xx'
      elsif doc.css('#link_disablemessag_own').inner_text != ''
        post.available = 'NG'
        post.error = doc.css('#link_disablemessag_own').inner_text
      elsif doc.css('#link_disablemessage_rights').inner_text != ''
        post.available = 'NG'
        post.error = doc.css('#link_disablemessage_rights').inner_text
      elsif !episode.nil?
        post.available = 'OK'

        direct_url = nil
        script = doc.css('#player > script').inner_text
        /var movie_url = (?<direct_url>['].*['])/=~ script
        if direct_url
          direct_url = direct_url.delete("'").delete('?')
          direct_url = URI.unescape(direct_url).sub('external:', '')
          save_direct_url(direct_url, post)
        end
      else
        post.available = 'INSPECTION'
        post.error = doc.css('#movie_title').inner_text
      end

      post.save
    end
  end
end
