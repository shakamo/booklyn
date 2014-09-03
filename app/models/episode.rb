class Episode < ActiveRecord::Base
  

  @@str = Hash.new
  @@str['あ'] = <<-S
    ('あ','い','う','え','お') 
    S
  @@str['か'] = <<-S
    ('か','き','く','け','こ') 
    S
  @@str['さ'] = <<-S
    ('さ','し','す','せ','そ') 
    S
  @@str['た'] = <<-S
    ('た','ち','つ','て','と') 
    S
  @@str['な'] = <<-S
    ('な','に','ぬ','ね','の') 
    S
  @@str['は'] = <<-S
    ('は','ひ','ふ','へ','ほ') 
    S
  @@str['ま'] = <<-S
    ('ま','み','む','め','も') 
    S
  @@str['や'] = <<-S
    ('や','ゆ','よ') 
    S
  @@str['ら'] = <<-S
    ('ら','り','る','れ','ろ') 
    S
  @@str['わ'] = <<-S
    ('わ','を','ん') 
    S
  
  belongs_to :content
  def get_recent
    sql = <<-SQL
    
    select
        c.id,
        c.title, '第' || e.episode_num || '話' as episode_num,
        e.episode_name,
        count(case                        
            when p.available = 'OK' then 1                
        end) as OK,
        count(case                        
            when p.available = 'NG' then 1                
        end) as NG,
        i.url,
        to_char(e.created_at, 'YYYYMMDDHH24MISS')    as created_at
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
        e.created_at,
        c.id,
        c.title,
        e.episode_num,
        e.episode_name,
        i.url        
    order by
        e.created_at desc limit 20
    SQL
    
    return ActiveRecord::Base.connection.select_all(sql)
  end
def get_recent_by_week(week)
  sql = <<-SQL
  
  select
      c.id,
      c.title, '第' || e.episode_num || '話' as episode_num,
      e.episode_name,
      count(case                        
          when p.available = 'OK' then 1                
      end) as OK,
      count(case                        
          when p.available = 'NG' then 1                
      end) as NG,
      i.url,
      to_char(e.created_at, 'YYYYMMDDHH24MISS')    as created_at
  from
      episodes e,
      contents c,
      posts p,
      images i,
      schedules s
  where
      c.id = e.content_id                
      and p.episode_id = e.id                
      and c.id = i.generic_id                
      and i.table_name = 'contents'
      and c.schedule_id = s.id
      and s.week = '#{week}'      
  group by
      e.created_at,
      c.id,
      c.title,
      e.episode_num,
      e.episode_name,
      i.url        
  order by
      e.created_at desc limit 20
  SQL
  
  return ActiveRecord::Base.connection.select_all(sql)
end
def get_recent_by_atoz(atoz)
  
  atoz = @@str[atoz]
  
sql = <<-SQL

select
    c.id,
    c.title, '第' || e.episode_num || '話' as episode_num,
    e.episode_name,
    count(case                        
        when p.available = 'OK' then 1                
    end) as OK,
    count(case                        
        when p.available = 'NG' then 1                
    end) as NG,
    i.url,
    to_char(e.created_at, 'YYYYMMDDHH24MISS')    as created_at
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
    and substring(c.initial for 1) IN #{atoz}
    
group by
    e.created_at,
    c.id,
    c.title,
    e.episode_num,
    e.episode_name,
    i.url        
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
