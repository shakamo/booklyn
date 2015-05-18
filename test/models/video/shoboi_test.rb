require 'test_helper'
require 'video/shoboi'

# Shoboi Test
class ShoboiTest < ActiveSupport::TestCase
  def setup
  end

  def test_1
    # 利用していない。
    assert_equal '/tid/3618', Video::Shoboi.new.search_path('アルドノア・ゼロ')
  end

  def test_2
    Video::Shoboi.new.import_all
  end

  def test_3
    # 値が存在すればOK、存在しなければキャストできずにエラーとなる。
    schedule = Video::Shoboi.new.get_schedule(4)
    assert schedule.id
  end

  def test_4
    schedule = Video::Shoboi.new.get_schedule(4)

    param = { id: 99_999, schedule_code: '01', schedule_name: :Mon, week: :Mon, date: '2003-04-07' }
    test = Schedule.new param

    assert_equal schedule.attributes.except('id').except('created_at').except('updated_at'), test.attributes.except('id').except('created_at').except('updated_at')
  end

  def test_5
    episodes = Video::Shoboi.new.get_episodes('*001*夕焼けと鉄骨・前編 *002*夕焼けと鉄骨・後編 *003*最高のニュース *004*夏の夜と魔法遣い *005*エプロンとシャンパン *006*魔法遣いになりたい *007*魔法遣いになれなかった魔法遣い *008*恋のバカヂカラ *009*ユメと少女と夏の種 *010*魔法の行方 *011*折れてしまった虹 *012*魔法遣いに大切なこと')
    assert_equal '001', episodes[0]
    assert_equal '夕焼けと鉄骨・前編 ', episodes[1]
    assert_equal '002', episodes[2]
    assert_equal '夕焼けと鉄骨・後編 ', episodes[3]
  end

  def test_6
    schedule = Video::Shoboi.new.get_schedule(1)
    assert schedule.id
  end

  def test_6
    schedule = Video::Shoboi.new.get_schedule(15)
    assert schedule.id
  end
end
