require 'test_helper'

class StandardMailerTest < ActiveSupport::TestCase
  def test_1
    array = GooLabs.call_morph('まじっく快斗1412　第12話')
    assert_equal array.size, 2
  end
end
