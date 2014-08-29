class Episode < ActiveRecord::Base
  belongs_to :content
  def get_recent
    sql = <<-SQL
    
      select
          c.title,
          '第' || e.episode_num || '話' as episode_num,
          e.episode_name,
          count(case 
              when p.available = 'OK' then 1
          end) as OK,
          count(case 
              when p.available = 'NG' then 1
          end) as NG,
          i.url,
to_char(e.created_at,'YYYYMMDDHH24MISS')
      from
          episodes e,
          contents c,
          posts p,
          images i 
      where
          c.id = e.content_id 
          and p.episode_id = e.id 
          and c.id = i.generic_id 
          and i.table_name = 'contents' 
      group by
          c.title,
          e.episode_num,
          e.episode_name,
          i.url,
          e.created_at 
      order by
          e.created_at desc limit 12
    SQL
    
    return ActiveRecord::Base.connection.select_all(sql)
  end
  def get_history
    sql = <<-SQL

    select
        a.*   
    from
        (select
            c.id,
            c.title,
            e.episode_num,
            e.episode_name,
            to_char(max(e.created_at),'YYYYMMDDHH24MI') as date
        from
            episodes e,
            contents c           
        where
            e.content_id = c.id           
        group by
            c.id ,
            c.title,
            e.episode_num,
            e.episode_name) as a  
    order by
        a.date desc limit 10
    SQL
    
    return ActiveRecord::Base.connection.select_all(sql)
  end
end
