require 'test_helper'

# Import Contents Test
class ImportContentsTest < ActiveSupport::TestCase
  def setup
  end

  def test_1
    assert_raises StandardError do
      ImportContents.new.perform_all(:Test, 2015, :winter, 50)
    end
  end

  def test_2
  end
end
