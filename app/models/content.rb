class Content < ActiveRecord::Base
  belongs_to :category
  belongs_to :schedule
  
end
