require 'test_helper'
#
class RegisterTfidfTest < ActiveSupport::TestCase
  def test_1
    assert RegisterTfidf.new.search
  end

  def test_2
    param = [{ 'id' => '1', 'title' => 'あいうえお' },
             { 'id' => '2', 'title' => 'あいうえお' }]
    RegisterTfidf.new.register param
  end

  def test_3
    RegisterTfidf.new.execute
  end
end
