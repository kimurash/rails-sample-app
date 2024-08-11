require 'test_helper'

class UsersSignup < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end
end

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test 'invalid signup information' do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: {
        user: {
          name: '',
          email: 'user@invalid',
          password: 'foo',
          password_confirmation: 'bar'
        }
      }
    end
    # HTTPステータスが正しいことを確認
    assert_response :unprocessable_entity
    # ユーザー登録画面が再描画されることを確認
    assert_template 'users/new'

    # エラーメッセージが表示されることを確認
    assert_select 'div#error_explanation'
    assert_select 'div.alert-danger'
  end

  test 'valid signup information with account activation' do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: {
        user: {
          name: 'Example User',
          email: 'user@example.com',
          password: 'password',
          password_confirmation: 'password'
        }
      }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
  end
end

class AccountActivationTest < UsersSignup
  def setup
    super
    post users_path, params: { user: { name: 'Example User',
                                       email: 'user@example.com',
                                       password: 'password',
                                       password_confirmation: 'password' } }
    @user = assigns(:user)
  end

  test 'should not be activated before activation' do
    log_in_as(@user)
    assert_not is_logged_in?
  end

  test 'should not be able to log in  with invalid activation token' do
    get edit_account_activation_path('invalid token', email: @user.email)
    assert_not is_logged_in?
  end

  test 'should not be able to log in with invalid email' do
    get edit_account_activation_path(@user.activation_token, email: 'wrong')
    assert_not is_logged_in?
  end

  test 'should log in successfully with valid activation token and email' do
    get edit_account_activation_path(@user.activation_token, email: @user.email)
    assert @user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
