class Post < ActiveRecord::Base
  belongs_to :episode
  belongs_to :contents_holder
  belongs_to :platform
end
