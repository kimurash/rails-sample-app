require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  #

  test 'login with invalid information' do
    # ログイン用のページにアクセス
    get login_path
    # 正しいページが表示されるか確認
    assert_template 'sessions/new'
    # 無効な情報を用いてPOST
    post login_path, params: { session: { email: '', password: '' } }
    # 正しいページが再表示されるか確認
    assert_template 'sessions/new'
    # flashメッセージが表示されるか確認
    assert_not flash.empty?
    # 別のページに移動
    get root_path
    # flashメッセージが消えているか確認
    assert flash.empty?
  end
end
