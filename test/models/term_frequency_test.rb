# == Schema Information
#
# Table name: term_frequencies
#
#  id         :integer          not null, primary key
#  content_id :integer
#  word       :string
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_term_frequencies_on_content_id  (content_id)
#

require 'test_helper'

class TermFrequencyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end