require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    # GETリクエストをhomeアクションに対して発行
    get static_pages_home_url
    # レスポンスは成功するはず
    # :successはステータスコード200を表す
    assert_response :success
  end

  test "should get help" do
    get static_pages_help_url
    assert_response :success
  end

  test "should get about" do
    get static_pages_about_url
    assert_response :success
  end
end
