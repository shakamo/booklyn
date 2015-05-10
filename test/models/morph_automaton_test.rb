require 'test_helper'
require 'goo_labs'
require 'url_utils'

# MorphAutomaton Test.
class MorphAutomatonTest < ActiveSupport::TestCase
  include GooLabs
  def test_1
    morph = call_morph('まじっく快斗1412 第12話')
    job = MorphAutomaton.new(morph)
    job.next_index(6)
    assert job.same?(%w(空白 冠数詞 Number 助数詞), two: %w(ダイ), four: %w(ワ))
  end

  def test_2
    morph = call_morph('まじっく快斗1412 12話')
    job = MorphAutomaton.new(morph)
    job.next_index(6)
    assert job.same?(%w(空白 Number 助数詞), three: %w(ワ))
  end

  def test_3
    morph = call_morph('まじっく快斗1412 #12')
    job = MorphAutomaton.new(morph)
    job.next_index(6)
    assert job.same?(%w(空白 Symbol Number), two: %w(シャープ))
  end

  def test_4
    morph = call_morph('まじっく快斗1412 #12')
    job = MorphAutomaton.new(morph)
    job.next_index(6)
    job.may_run?

    assert_equal job.title, 'まじっく快斗1412'
    assert_equal job.episode_num, 12
    assert_equal job.episode_name, nil
  end

  def test_11
    str = 'まじっく快斗1412 第12話「あ」'

    morph = call_morph(str)
    job = MorphAutomaton.new(morph)

    job.auto

    assert_equal job.title, 'まじっく快斗1412'
    assert_equal job.episode_num, 12
    assert_equal job.episode_name, 'あ'
  end

  def test_12
    str = 'Fate／stay night[フェイト／ステイナイト][ufotable版] 2ndシーズン'

    morph = call_morph(str)
    job = MorphAutomaton.new(morph)

    job.auto

    assert_equal job.title, 'Fate／stay night[フェイト／ステイナイト][ufotable版] 2ndシーズン'
    assert_equal job.episode_num, nil
    assert_equal job.episode_name, nil
  end

  def test_13
    str = 'ログ・ホライズン 第2シリーズ　第13話'

    morph = call_morph(str)
    job = MorphAutomaton.new(morph)

    job.auto

    assert_equal job.title, 'ログ・ホライズン 第2シリーズ'
    assert_equal job.episode_num, 13
    assert_equal job.episode_name, nil
  end

  def test_14
    str = 'HUNTER×HUNTER　第146話'

    morph = call_morph(str)
    job = MorphAutomaton.new(morph)

    job.auto

    assert_equal job.title, 'HUNTER×HUNTER'
    assert_equal job.episode_num, 146
    assert_equal job.episode_name, nil
  end


  def test_15
    str = 'アカメが斬る！　第特別総集編 1話'

    morph = call_morph(str)
    job = MorphAutomaton.new(morph)

    job.auto

    assert_equal job.title, 'アカメが斬る！　第特別総集編'
    assert_equal job.episode_num, 1
    assert_equal job.episode_name, nil
  end

  def test_16
    str = 'あの夏で待ってる OVA ねこちゃんＢＤ高画質「僕達は高校最後の夏を過ごしながら、あの夏を待っている。」 - ひまわり動画'

    # assert_nil RegexUtils.get_episode_num(str)
    # assert_nil RegexUtils.get_episode_string(str)
    # assert_equal 'あの夏で待ってる OVA', RegexUtils.get_title(str)
    # assert_equal 'あの夏で待ってるOVA', RegexUtils.get_title_trim(str)
    # assert_equal 'あの夏で待ってる%OVA', RegexUtils.get_title_query(str)
    # assert_nil RegexUtils.get_title_for_anikore(str)
    # assert_equal '僕達は高校最後の夏を過ごしながら、あの夏を待っている。', RegexUtils.get_sub_title(str)
  end

  def test_17
    str = '六畳間の侵略者！？ 第09話 「陽だまりと虹」 - ひまわり動画'

    morph = call_morph(str)
    job = MorphAutomaton.new(morph)

    job.auto

    assert_equal job.title, '六畳間の侵略者！？'
    assert_equal job.episode_num, 9
    assert_equal job.episode_name, '陽だまりと虹'
  end

  def test_18
    str = 'ひめゴト #08 「はじめてだから優しくしてください」 - ひまわり動画'

    morph = call_morph(str)
    job = MorphAutomaton.new(morph)

    job.auto

    assert_equal job.title, 'ひめゴト'
    assert_equal job.episode_num, 8
    assert_equal job.episode_name, 'はじめてだから優しくしてください'
  end

  def test_21
    str = 'ドラマ24「怪奇恋愛作戦」'

    # assert_nil RegexUtils.get_episode_num(str)
    # assert_nil RegexUtils.get_episode_string(str)
    # assert_equal 'ドラマ24「怪奇恋愛作戦」', RegexUtils.get_title(str)
    # assert_equal 'ドラマ24怪奇恋愛作戦', RegexUtils.get_title_trim(str)
    # assert_equal 'ドラマ24%怪奇恋愛作戦%', RegexUtils.get_title_query(str)
    # assert_nil RegexUtils.get_title_for_anikore(str)
    # assert_nil RegexUtils.get_sub_title(str)
  end

  def test_22
    str = 'ドラマ24「怪奇恋愛作戦」'

    # assert_nil RegexUtils.get_episode_num(str)
    # assert_nil RegexUtils.get_episode_string(str)
    # assert_equal 'ドラマ24「怪奇恋愛作戦」', RegexUtils.get_title(str)
    # assert_equal 'ドラマ24怪奇恋愛作戦', RegexUtils.get_title_trim(str)
    # assert_equal 'ドラマ24%怪奇恋愛作戦%', RegexUtils.get_title_query(str)
    # assert_nil RegexUtils.get_title_for_anikore(str)
    # assert_nil RegexUtils.get_sub_title(str)
  end
end
