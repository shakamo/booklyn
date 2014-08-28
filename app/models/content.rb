class Content < ActiveRecord::Base
  belongs_to :category
  belongs_to :schedule

  def get_list_by_id(id)
    return ActiveRecord::Base.connection.select_all("select * from contents where id = " + id)
  end
end
