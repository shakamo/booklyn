# == Schema Information
#
# Table name: contents_holders
#
#  id                   :integer          not null, primary key
#  contents_holder_code :string
#  contents_holder_name :string
#  created_at           :datetime
#  updated_at           :datetime
#
# Indexes
#
#  index_contents_holders_on_contents_holder_code  (contents_holder_code)
#

require 'test_helper'

class ContentsHolderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
