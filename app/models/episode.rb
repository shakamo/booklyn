class Episode < ActiveRecord::Base
  belongs_to :content
  def get_recent
    return ActiveRecord::Base.connection.select_all("select * from episodes order by id desc limit 9")
  end
end
