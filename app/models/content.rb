class Content < ActiveRecord::Base
  belongs_to :category
  belongs_to :schedule

  def get_list_by_id(id)
    sql = <<-SQL
    
    select
        contents.*,
        images.url 
    from
        contents,
        images 
    where
        images.table_name = 'contents' 
        and images.generic_id = contents.id 
        and contents.id = 
    SQL
    
    return ActiveRecord::Base.connection.select_all(sql + id)
  end
end
