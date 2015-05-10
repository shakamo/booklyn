# == Schema Information
#
# Table name: direct_urls
#
#  id         :integer          not null, primary key
#  post_id    :integer
#  direct_url :string
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class DirectUrlTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
