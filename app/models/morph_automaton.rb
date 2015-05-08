
#
class MorphAutomaton
  include AASM

  attr_accessor :title, :episode_num, :episode_name

  def initialize(morph)
    @word = %w(Number)
    @morph = { raw: [], morph: [], kana: [] }

    @index = 0

    @morph[:raw] << morph[:raw]
    @morph[:morph] << morph[:morph]
    @morph[:kana] << morph[:kana]
  end

  aasm do
    state :Title, initial: true
    state :Episode
    state :Subtitle
    state :Scrap

    event :next do
      tranditions from: Title, to: Episode, guard: episode?
      tranditions from: Episode, to: Subtitle, guard: subtitle?
      tranditions from: Episode, to: Scrap, guard: scrap?
      tranditions from: Subtitle, to: Scrap, guard: scrap?
    end
  end

  def episode?
    if same?(%w(Symbol Number), one: %w(シャープ), two: %w(シャープ), three: %w(シャープ))
      return true
    elsif same?(%w(Number 助数詞), %w(助数詞))
      return true
    elsif same?(%w(冠数詞 Symbol 助数詞), %w())
      true
    end
    false
  end

  def same?(morph, kana = {})
    false if morph != @morph[:morph][@index..morph.size]

    false if kana[:one].include?(@morph[:kana][@index])
    false if kana[:two].include?(@morph[:kana][@index + 1])
    false if kana[:three].include?(@morph[:kana][@index + 2])
    true
  end
end
