require 'open-uri'
require 'nokogiri'
require 'chronic'
require 'uri'

module Scrape
  class EpisodeManager
    def self.createAll(site_name)
    	if site_name == 'tvanimedouga'
    		ScrapeTvanimedouga.createAll()
    	end
    end

    def self.update(site_name, count)
    	if site_name == 'tvanimedouga' then
      	ScrapeTvanimedouga.update(count)
    	end
    end

    def self.get_episode(content, episode_num)
      episode = Episode.find_or_initialize_by(content_id: content.id, episode_num: episode_num)
      set_episode_name(content, episode)
      episode.save
      return episode
    end

    def self.set_episode_name(content, episode)
    	episode_name = Scrape::ShoboiContent.get_episode_name(content, episode)
    	if episode_name != episode.episode_name then
    		episode.episode_name = episode_name
    	end
    end
  end
end
