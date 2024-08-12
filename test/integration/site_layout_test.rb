require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test 'layout links' do
    # ルートURLにアクセス
    get root_path
    # レスポンスは成功するはず
    assert_response :success
    # 正しいビューをレンダリングしているかテスト
    assert_template 'static_pages/home'
    # レイアウトリンクが正しいかテスト
    # ルートURLへのリンクは2つあるはず
    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', login_path

    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', contact_path

    log_in_as(@user)
    follow_redirect!
    assert_template 'users/show'

    get root_path

    assert_select 'a[href=?]', users_path
    assert_select 'a[href=?]', user_path(@user)
    assert_select 'a[href=?]', edit_user_path(@user)
    assert_select 'a[href=?]', logout_path

    assert_select 'a[href=?]', following_user_path(@user)
    assert_select 'a[href=?]', followers_user_path(@user)

    assert_select 'div.stats' do
      assert_select '#following', text: @user.following.count.to_s
      assert_select '#followers', text: @user.followers.count.to_s
    end

    # Sign upのリンクをクリックして正しいページに遷移するかテスト
    get signup_path
    assert_select 'title', full_title('Sign up')
  end
end
