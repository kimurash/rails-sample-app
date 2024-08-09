require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  #
  def setup
    @user = users(:michael)
  end

  test 'login with invalid information' do
    # ログイン用のページにアクセス
    get login_path
    # 正しいページが表示されるか確認
    assert_template 'sessions/new'
    # 無効な情報を用いてPOST
    post login_path,
         params: {
           session: {
             email: 'michael@example.com',
             password: 'invalid'
           }
         }
    # 正しいページが再表示されるか確認
    assert_template 'sessions/new'
    # flashメッセージが表示されるか確認
    assert_not flash.empty?
    # 別のページに移動
    get root_path
    # flashメッセージが消えているか確認
    assert flash.empty?
  end

  test 'login with valid information' do
    # GETする必要はない
    # get login_path
    post login_path,
         params: {
           session: {
             email: @user.email,
             password: 'password'
           }
         }

    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'

    # ログインリンクが消えていることを確認
    assert_select 'a[href=?]', login_path, count: 0
    # ログアウトリンクが表示されていることを確認
    assert_select 'a[href=?]', logout_path
    # プロフィールリンクが表示されていることを確認
    assert_select 'a[href=?]', user_path(@user)
  end
end
