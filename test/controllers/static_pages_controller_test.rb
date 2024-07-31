require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    # GETリクエストをhomeアクションに対して発行
    get static_pages_home_url
    # レスポンスは成功するはず
    # :successはステータスコード200を表す
    assert_response :success
    # 特定のHTMLタグが存在するかどうかをテスト
    assert_select "title", "Home | Ruby on Rails Tutorial Sample App"
  end

  test "should get help" do
    get static_pages_help_url
    assert_response :success
    assert_select "title", "Help | Ruby on Rails Tutorial Sample App"
  end

  test "should get about" do
    get static_pages_about_url
    assert_response :success
    assert_select "title", "About | Ruby on Rails Tutorial Sample App"
  end
end
