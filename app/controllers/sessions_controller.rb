class SessionsController < ApplicationController
  def new; end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user&.authenticate(params[:session][:password])
      forwarding_url = session[:forwarding_url]
      # セッション固定を防ぐために
      # ログインの直前に必ずセッションをリセットする
      reset_session
      # ユーザーを記憶する
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      # ログイン後にユーザー情報のページにリダイレクトする
      log_in(@user)
      redirect_to forwarding_url || @user
    else
      # エラーメッセージを作成する
      flash.now[:danger] = 'Invalid email/password combination'
      render('new', status: :unprocessable_entity)
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end
end
