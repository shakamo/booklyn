require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  def setup
    @controller = ApiController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end

  def test_1
    post :recent

    assert_response :success
    json = JSON.parse(@response.body)
  end
end
