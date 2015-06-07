require 'open-uri'
require 'nokogiri'
require 'logger'
require 'net/http'
require 'uri'

class HolderTest < ActiveSupport::TestCase
  include Holder
  def setup
  end

  def test_1
    save_direct_url('http://test.com/test.mp4', Post.new)
  end
end
