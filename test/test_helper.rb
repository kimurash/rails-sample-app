ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/reporters'
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # test環境でもApplicationヘルパーを使えるようにする
  include ApplicationHelper

  # Add more helper methods to be used by all tests here...

  # テストユーザーがログイン中の場合にtrueを返す
  # Sessionヘルバーをincludeしてlogged_in?メソッドを使うこともできるが
  # cookieの扱いが原因で失敗する
  def is_logged_in?
    !session[:user_id].nil?
  end

  # 単体テスト用
  # テストユーザーとしてログインする
  def log_in_as(user)
    session[:user_id] = user.id
  end
end

class ActionDispatch::IntegrationTest
  # 統合テスト用
  # テストユーザーとしてログインする
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password:,
                                          remember_me: } }
  end
end
