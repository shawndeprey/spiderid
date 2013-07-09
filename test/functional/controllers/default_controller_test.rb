require 'test_helper'

class DefaultControllerTest < ActionController::TestCase
  setup do
    # @user = FactoryGirl.create(:user, admin: true)
  end

  test "should display index" do
    get :index
    assert_response :success
    assert_match(/<h2>Welcome to Spider ID\!<\/h2>/, response.body)
  end

end
