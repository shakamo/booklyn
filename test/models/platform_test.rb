# == Schema Information
#
# Table name: platforms
#
#  id            :integer          not null, primary key
#  platform_code :string
#  platform_name :string
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_platforms_on_platform_code  (platform_code)
#

require 'test_helper'

class PlatformTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
