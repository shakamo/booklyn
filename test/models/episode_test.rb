# == Schema Information
#
# Table name: episodes
#
#  id           :integer          not null, primary key
#  episode_num  :integer
#  episode_name :string
#  content_id   :integer
#  created_at   :datetime
#  updated_at   :datetime
#  error        :text
#
# Indexes
#
#  index_episodes_on_content_id   (content_id)
#  index_episodes_on_episode_num  (episode_num)
#

require 'test_helper'

class EpisodeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
