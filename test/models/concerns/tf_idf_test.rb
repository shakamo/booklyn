require 'test_helper'
require 'tf_idf'
require 'goo_labs'
require 'url_utils'

# Shoboi Test
class TfIdfTest < ActiveSupport::TestCase
  include TfIdf
  def setup
  end

  def test_1
    morph = call_morph('あいうえお')
    assert get_tfidf(morph).key?('content_id')
    assert get_tfidf(morph).key?('tfidf')

    puts get_tfidf(morph).to_s
  end

  def test_2
    morph = call_morph('うえお')
    assert get_tfidf(morph).key?('content_id')
  end

  def test_3
    morph = call_morph("あ'い'う")
    assert get_tfidf(morph)
  end
end
