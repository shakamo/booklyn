require 'open-uri'
require 'nokogiri'
require 'chronic'
require 'uri'

class ImportEpisodes
  def self.createAll(site_name)
    ScrapeTvanimedouga.createAll if site_name == 'tvanimedouga'
  end

  def self.update(site_name, count)
    if site_name == 'tvanimedouga'
      ScrapeTvanimedouga.update(count)
    elsif site_name == 'tvdramadouga'
      ScrapeTvdramadouga.update(count)
    end
  end

  def self.get_episode(content, episode_num)
    episode = Episode.find_or_initialize_by(content_id: content.id, episode_num: episode_num)
    set_episode_name(content, episode)
    episode.save
    episode
  end

  def self.set_episode_name(content, episode)
    p content.to_yaml
    episode_name = Scrape::ShoboiContent.get_episode_name(content, episode)
    episode.episode_name = episode_name if episode_name != episode.episode_name
  end
end
