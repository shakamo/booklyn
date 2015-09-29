require 'test_helper'

# Import Contents Test
class ImportContentsTest < ActiveSupport::TestCase
  def setup
  end

  def test_1
    assert_raises StandardError, ImportContents.new.perform_all(:Test, 2015, :winter, 50)
  end

  def test_2
  end
end
