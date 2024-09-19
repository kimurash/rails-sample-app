class PasswordResetsController < ApplicationController
  before_action :get_user, only: %i[edit update]
  before_action :valid_user, only: %i[edit update]
  # パスワード再設定の有効期限が切れていないか
  before_action :check_expiration, only: %i[edit update]

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    return if @user&.activated? && @user&.authenticated?(:reset, params[:id])

    redirect_to root_url
  end

  # 期限切れかどうかを確認する
  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = 'Password reset has expired.'
    redirect_to new_password_reset_url
  end

  public

  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      # リダイレクトする場合
      flash[:info] = 'Email sent with password reset instructions'
      redirect_to root_url
    else
      # リダイレクトしない場合
      flash.now[:danger] = 'Email address not found'
      render 'new', status: :unprocessable_entity
    end
  end

  def edit; end

  def update # rubocop:disable Metrics
    # 新しいパスワードと確認用パスワードが空文字列になっていないか
    # ユーザー情報の編集ではOKだった
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit', status: :unprocessable_entity
    # 新しいパスワードが正しければ、更新する
    elsif @user.update(user_params)
      # DBから記憶トークンを削除
      @user.forget
      # セッションに保存された情報を削除
      reset_session
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = 'Password has been reset.'
      redirect_to @user
    else
      # 無効なパスワードであれば失敗させる
      # 失敗した理由も表示する
      render 'edit', status: :unprocessable_entity
    end
  end
end
