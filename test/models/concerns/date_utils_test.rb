require 'test_helper'
require 'date_utils'

# GooLabs Test
class DateUtilsTest < ActiveSupport::TestCase
  include DateUtils
  def setup
    Time.zone = 'Asia/Tokyo'
    Chronic.time_class = Time.zone
  end

  def test_1
    assert_equal :Sun, get_week(0)
  end
end
