require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get dashboard" do
    get dashboard_dashboard_url
    assert_response :success
  end

  test "should get repositories" do
    get dashboard_repositories_url
    assert_response :success
  end

  test "should get people" do
    get dashboard_people_url
    assert_response :success
  end
end
