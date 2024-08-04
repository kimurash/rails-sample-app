class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # セッション固定を防ぐために
      # ログインの直前に必ずセッションをリセットする
      reset_session
      # ログイン後にユーザー情報のページにリダイレクトする
      log_in user
      redirect_to user
    else
      # エラーメッセージを作成する
      flash.now[:danger] = 'Invalid email/password combination'
      render('new', status: :unprocessable_entity)
    end
  end

  def destroy; end
end
