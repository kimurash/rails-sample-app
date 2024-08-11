class ApplicationController < ActionController::Base
  # どのコントローラからでもログイン関連のメソッドを
  # 呼び出せるようにする
  include SessionsHelper

  private

  # ユーザーのログインを確認する
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = 'Please log in.'
    redirect_to(login_url, status: :see_other)
  end
end
