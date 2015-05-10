# == Schema Information
#
# Table name: schedules
#
#  id            :integer          not null, primary key
#  schedule_code :string
#  schedule_name :string
#  week          :string
#  created_at    :datetime
#  updated_at    :datetime
#  date          :date
#
# Indexes
#
#  index_schedules_on_schedule_code  (schedule_code)
#

require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
