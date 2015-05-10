# == Schema Information
#
# Table name: contents
#
#  id          :integer          not null, primary key
#  title       :string
#  initial     :string
#  description :string(8192)
#  category_id :integer
#  schedule_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#  trim_title  :string
#  error       :text
#
# Indexes
#
#  index_contents_on_category_id  (category_id)
#  index_contents_on_schedule_id  (schedule_id)
#

require 'test_helper'

class ContentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
