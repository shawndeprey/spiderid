require 'test_helper'

class Api::V1::DefaultControllerTest < ActionController::TestCase
  setup do
    # @user = FactoryGirl.create(:user)
  end

  test "should display api index" do
  	get :index, format: "json"
  	assert_response :success
  	json = ActiveSupport::JSON.decode response.body
  	json.has_key?("app_name").must_equal true
    json.has_key?("total_families").must_equal true
    json.has_key?("total_genus").must_equal true
    json.has_key?("total_arachnids").must_equal true
  end

end