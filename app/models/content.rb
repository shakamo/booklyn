# == Schema Information
#
# Table name: contents
#
#  id          :integer          not null, primary key
#  title       :string
#  initial     :string
#  description :string(8192)
#  category_id :integer
#  schedule_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#  trim_title  :string
#  error       :text
#
# Indexes
#
#  index_contents_on_category_id  (category_id)
#  index_contents_on_schedule_id  (schedule_id)
#
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
    order by
        e.episode_num desc
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
      episode['posts'] = []

      posts.each do |post|
        if (episode['episode_num'] == post['episode_num'])
          episode['posts'] << post
        end
      end
    end
    content
  end
end
