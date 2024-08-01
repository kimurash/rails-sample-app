require "test_helper"

class SiteLayoutTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "layout links" do
    # ルートURLにアクセス
    get root_path
    # レスポンスは成功するはず
    assert_response :success
    # 正しいビューをレンダリングしているかテスト
    assert_template "static_pages/home"
    # レイアウトリンクが正しいかテスト
    # ルートURLへのリンクは2つあるはず
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path

    # Contactのリンクをクリックして正しいページに遷移するかテスト
    get contact_path
    assert_select "title", full_title("Contact")
  end
end
