require 'test_helper'
require 'goo_labs'
require 'tf_idf'
require 'video/dailymotion'
require 'video/tvanimedouga'

# Shoboi Test
class DailymotionTest < ActiveSupport::TestCase
  include GooLabs, TfIdf
  def setup
  end

  def test_1
    tvanimedouga = Video::Tvanimedouga.new
    morph = call_morph('あいうえお #11')

    content = tvanimedouga.get_content(morph)
    assert content, 'no content'
    episode = tvanimedouga.get_episode(morph, content)
    assert episode, 'no episode'

    Video::Dailymotion.new.execute('http://www.dailymotion.com/video/x378b86', content, episode)
  end
end
