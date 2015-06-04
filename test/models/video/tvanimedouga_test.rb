require 'test_helper'
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
  end

  def test_5
  end
end
