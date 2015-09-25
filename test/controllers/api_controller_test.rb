require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  def setup
  end

  def test_1
    post :recent

    puts @response.body.inspect
    json = JSON.parse(response.body)

    puts json

    assert_response :success
  end
end
