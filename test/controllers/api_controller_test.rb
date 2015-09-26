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

  def test_2
    post :content, id: 1252

    puts @response.body.inspect
    json = JSON.parse(response.body) if response.body.blank?

    assert_response :success
  end
end
