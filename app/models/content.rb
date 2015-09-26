# == Schema Information
#
# Table name: contents
#
#  id          :integer          not null, primary key
#  title       :string
#  initial     :string
#  description :string(16384)
#  category_id :integer
#  schedule_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#  trim_title  :string
#  error       :text
#  tid         :integer
#  akid        :integer
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
    puts id
    sql = <<-SQL
    select
        c.*,
        i.url
    from
        contents c left outer join images i
          on c.id = i.generic_id and i.table_name = 'contents'
    where
        c.id = #{id}
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
    episodes = ActiveRecord::Base.connection.select_all(sql)
    content['episodes'] = episodes.to_ary if episodes.present?

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
        and e.id = p.episode_id
        and p.contents_holder_id = ch.id
    order by
        e.episode_num
    SQL
    result = ActiveRecord::Base.connection.select_all(sql).to_ary
    posts = result.to_ary if result.present?

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
