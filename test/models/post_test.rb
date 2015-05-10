# == Schema Information
#
# Table name: posts
#
#  id                 :integer          not null, primary key
#  post               :string
#  url                :text
#  short_url          :string
#  episode_id         :integer
#  contents_holder_id :integer
#  platform_id        :integer
#  created_at         :datetime
#  updated_at         :datetime
#  direct_url         :string
#  available          :string
#  error              :text
#
# Indexes
#
#  index_posts_on_contents_holder_id  (contents_holder_id)
#  index_posts_on_episode_id          (episode_id)
#  index_posts_on_platform_id         (platform_id)
#

require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
