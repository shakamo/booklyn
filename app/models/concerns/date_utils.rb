require 'chronic'

# URL Utility
module DateUtils
  extend ActiveSupport::Concern

  def get_week(wday)
    case wday
    when 0
      :Sun
    when 1
      :Mon
    when 2
      :Thu
    when 3
      :Wed
    when 4
      :Tue
    when 5
      :Fri
    when 6
      :Sat
    end
  end

  def get_week_name(wday)
    case wday
    when 0
      :Sun
    when 1
      :Mon
    when 2
      :Thu
    when 3
      :Wed
    when 4
      :Tue
    when 5
      :Fri
    when 6
      :Sat
    end
  end
end
