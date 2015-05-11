# == Schema Information
#
# Table name: errors
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  url         :text
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class ErrorTest < ActiveSupport::TestCase
  def setup
  end

  def test_1
    error = Error.new
    assert_equal 'test_1', error.method_name
  end

  def test_2
    error = Error.new
    assert_equal 'error_test', error.class_name
  end
end
