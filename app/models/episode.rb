# == Schema Information
#
# Table name: episodes
#
#  id           :integer          not null, primary key
#  episode_num  :integer
#  episode_name :string
#  content_id   :integer
#  created_at   :datetime
#  updated_at   :datetime
#  error        :text
#
# Indexes
#
#  index_episodes_on_content_id   (content_id)
#  index_episodes_on_episode_num  (episode_num)
#

class Episode < ActiveRecord::Base
  @@str = {}
  @@str['a'] = <<-S
    ('あ','い','う','え','お')
    S
  @@str['k'] = <<-S
    ('か','き','く','け','こ')
    S
  @@str['s'] = <<-S
    ('さ','し','す','せ','そ')
    S
  @@str['t'] = <<-S
    ('た','ち','つ','て','と')
    S
  @@str['n'] = <<-S
    ('な','に','ぬ','ね','の')
    S
  @@str['h'] = <<-S
    ('は','ひ','ふ','へ','ほ')
    S
  @@str['m'] = <<-S
    ('ま','み','む','め','も')
    S
  @@str['y'] = <<-S
    ('や','ゆ','よ')
    S
  @@str['r'] = <<-S
    ('ら','り','る','れ','ろ')
    S
  @@str['w'] = <<-S
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
        contents c left outer join images i
            on c.id = i.generic_id and i.table_name = 'contents',
        posts p
    where
        c.id = e.content_id
        and p.episode_id = e.id
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
    ActiveRecord::Base.connection.select_all(sql)
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

    ActiveRecord::Base.connection.select_all(sql)
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

    ActiveRecord::Base.connection.select_all(sql)
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

    ActiveRecord::Base.connection.select_all(sql)
  end
end
