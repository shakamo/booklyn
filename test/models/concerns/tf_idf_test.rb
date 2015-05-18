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
    assert get_tfidf('あいうえお')[0].key?('content_id')
  end

  def test_2
    assert get_tfidf('うえお')[0].key?('content_id')
  end
end
