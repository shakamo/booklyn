require 'test_helper'

# MorphAutomaton Test.
class MorphAutomatonTest < ActiveSupport::TestCase
  def test_1
    job = MorphAutomaton.new('まじっく快斗1412 第12話')
    job.may_title?
  end
end
