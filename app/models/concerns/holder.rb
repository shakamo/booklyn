require 'open-uri'
require 'nokogiri'
require 'chronic'
require 'uri'

module Holder
  def create_post(url, episode, holder_name, platform_name)
    post = Post.find_or_initialize_by(url: url)
    if episode
      post.episode_id = episode.id
    else
      post.url = url
    end
    contents_holder = ContentsHolder.find_or_initialize_by(contents_holder_name: holder_name)
    post.contents_holder_id = contents_holder.id

    platform = Platform.find_or_initialize_by(platform_name: platform_name)
    post.platform_id = platform.id

    post
  end

  def get_episode(trim_title, episode_num)
    contents = Content.where(Content.arel_table[:trim_title].eq(trim_title))

    if contents && contents.size == 1
      episode = Episode.find_or_initialize_by(content_id: contents.first.id, episode_num: episode_num)
      episode.save
      return episode
    end

    contents = Content.where((Content.arel_table[:trim_title].matches(trim_title + '%')
    .or(Content.arel_table[:trim_title].matches('%' + trim_title)
    .or(Content.arel_table[:trim_title].matches('%' + trim_title + '%')))))

    if contents && contents.size == 1
      episode = Episode.find_or_initialize_by(content_id: contents.first.id, episode_num: episode_num)
      episode.save
      return episode
    else
      error = Error.find_or_initialize_by(name: 'NotFoundContent', description: trim_title)
      error.save
      return nil
    end
  end

  def set_error(entity, error_name, error_description)
    current = entity.error.to_s
    error = '[' + error_name + ']' + error_description + ' '
    entity.error = current + error
    p error
  end

  def save_direct_url(url, post)
    if Common::UrlUtils.instance.check_direct_url(url)
      direct_url = DirectUrl.find_or_initialize_by(direct_url: url)
      direct_url.post_id = post.id
      direct_url.save
    end
  end
  end
