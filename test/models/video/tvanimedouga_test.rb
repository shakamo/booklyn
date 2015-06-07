require 'test_helper'
require "open-uri"
require 'goo_labs'
require 'tf_idf'
require 'video/tvanimedouga'

# Shoboi Test
class TvanimedougaTest < ActiveSupport::TestCase
  include GooLabs, TfIdf
  def setup
  end

  def test_1
    assert Video::Tvanimedouga.new
  end

  def test_2
    list = Video::Tvanimedouga.new.get_list
    assert_equal list.size, 100
  end

  def test_3
    tvanimedouga = Video::Tvanimedouga.new
    morph = call_morph('あいうえお #11')

    content = tvanimedouga.get_content(morph)
    assert content
    episode = tvanimedouga.get_episode(morph, content)
    assert episode
  end

  def test_4
    tvanimedouga = Video::Tvanimedouga.new
    morph = call_morph('あいうえお #11')

    assert tvanimedouga.get_content(morph)
  end

  def test_5
    tvanimedouga = Video::Tvanimedouga.new
    morph = call_morph('あいうえお #11')

    content = Content.new({id: 99992})

    episode = tvanimedouga.get_episode(morph, content)
    assert episode
  end

  def test_6
    tvanimedouga = Video::Tvanimedouga.new
    morph = call_morph('あいうえお #11')

    content = Content.new({id: 99992})

    episode = tvanimedouga.get_episode(morph, content)
    assert episode

    tvanimedouga.import_detail 'blog-entry-21354.html', content, episode
  end

  def test_7
doc = Nokogiri::HTML.parse(open('http://up.b9dm.com/lz/66258.html', "r:CP51932").read.encode("UTF-8"))
  end
end
