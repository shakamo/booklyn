# == Schema Information
#
# Table name: errors
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  url         :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Error < ActiveRecord::Base
end
