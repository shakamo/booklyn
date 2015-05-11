require 'test_helper'
require 'shoboi'

# Shoboi Test
class ShoboiTest < ActiveSupport::TestCase
  include Shoboi

  def setup
  end

  def test_1
    assert_equal '/tid/3618', search_path('アルドノア・ゼロ')
  end

  def test_2
    assert get_schedule('アルドノア・ゼロ')
  end

  def test_3
    import_all
  end
end
