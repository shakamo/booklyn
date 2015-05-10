# == Schema Information
#
# Table name: categories
#
#  id            :integer          not null, primary key
#  category_code :string
#  category_name :string
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_categories_on_category_code  (category_code)
#

class Category < ActiveRecord::Base
end
