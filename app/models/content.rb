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
        and contents.id = #{id}
    SQL
    content = ActiveRecord::Base.connection.select_all(sql).to_ary[0]
    
    sql = <<-SQL
    
    select
        e.episode_num,
        e.episode_name,
        to_char(max(e.created_at),'YYYYMMDDHH24MI') as created_at
    from
        episodes e         
    where
        e.content_id = #{id}            
    group by
        e.episode_num,
        e.episode_name
    SQL
    content['episodes'] = ActiveRecord::Base.connection.select_all(sql).to_ary
    
    sql = <<-SQL
    
  select
      e.episode_num,
      p.url,
      p.direct_url,
      p.available,
      ch.contents_holder_name     
  from
      episodes e,
      posts p,
      contents_holders ch              
  where
  e.content_id = #{id}         
      and     e.id = p.episode_id         
      and p.contents_holder_id = ch.id     
  order by
      e.episode_num
    SQL
    posts = ActiveRecord::Base.connection.select_all(sql).to_ary
    
    content['episodes'].each do |episode|
      episode['posts'] = Array.new
      
      posts.each do |post|
        p episode['episode_num'] +  post['episode_num']
        if(episode['episode_num'] == post['episode_num'])
          episode['posts'] << post
        end
      end
    end
    p content
    return content
  end
end
