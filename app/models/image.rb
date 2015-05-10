# == Schema Information
#
# Table name: images
#
#  id         :integer          not null, primary key
#  url        :string
#  created_at :datetime
#  updated_at :datetime
#  table_name :string
#  generic_id :integer
#

class Image < ActiveRecord::Base
end
