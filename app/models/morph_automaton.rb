
#
class MorphAutomaton
  include AASM

  attr_accessor :title, :episode_num, :episode_name

  def initialize(morph)
    @word = %w(Number)
    @index = 0

    @morph = {}
    @morph[:raw] = morph[:raw]
    @morph[:morph] = morph[:morph]
    @morph[:kana] = morph[:kana]
  end

  aasm do
    state :Title, initial: true
    state :Episode
    state :Subtitle
    state :Scrap

    event :run do
      transitions from: :Title, to: :Episode, guard: :episode?
      transitions from: :Episode, to: :Subtitle, guard: :subtitle?
      transitions from: :Episode, to: :Scrap, guard: :scrap?
      transitions from: :Subtitle, to: :Scrap, guard: :scrap?
    end
  end

  def episode?
    if same?(%w(空白 Symbol Number), two: %w(シャープ))
      end_index = @index + 2
    elsif same?(%w(空白 Number 助数詞), three: %w(ワ))
      end_index = @index + 1
    elsif same?(%w(空白 冠数詞 Number 助数詞), two: %w(ダイ), four: %w(ワ))
      end_index = @index + 2
    else
      return false
    end

    @episode_num = @morph[:raw][end_index].to_i
    @title = @morph[:raw][0, @index].join
    true
  end

  def subtitle?
    fail 'Multiple Symbol(括弧)' + morph[:raw] if 2 < @morph[:morph].count do |item|
      item == '括弧'
    end

    tail = @morph[:morph][@index + 1..-1]

    if @morph[:morph][@index] == '括弧' && tail.include?('括弧')
      @episode_name = @morph[:raw][@index + 1, tail.index('括弧')].join
      return true
    end
    false
  end

  def scrap?
    return false if @morph[:morph][@index..-1].include?('括弧')
    true
  end

  def same?(morph, kana, index = @index)
    if morph == @morph[:morph][index, morph.size] &&
       include?(kana[:one], @morph[:kana][index]) &&
       include?(kana[:two], @morph[:kana][index + 1]) &&
       include?(kana[:three], @morph[:kana][index + 2]) &&
       include?(kana[:four], @morph[:kana][index + 3])
      return true
    end
    false
  end

  def include?(kana, word)
    return true if kana.nil?
    return false if word.nil?
    return true if kana.include?(word)
    false
  end

  def next_index(i = 1)
    return false if end?
    @index += i
    true
  end

  def end?
    return true if @morph[:morph].size <= @index
    false
  end

  def auto
    run if may_run? while next_index
    @title = @morph[:raw].join if @title.nil?
  end
end
