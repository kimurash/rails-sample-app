require 'rails_helper'

RSpec.describe 'AccountActivations', type: :request do
  describe 'Get /account_activations/:id/edit' do
    before do
      post(
        users_path,
        params: {
          user: { name: 'Example User', email: 'user@example.com',
                  password: 'password', password_confirmation: 'password' }
        }
      )

      # コントローラ(UsersController#create)で使用しているインスタンス変数を取得
      @reset_user = controller.instance_variable_get('@user')
    end

    context 'when token is invalid' do
      before do
        get edit_account_activation_path('invalid token', email: @reset_user.email)
      end

      it 'redirects to root_url' do
        expect(flash[:danger]).to be_present
        expect(response).to redirect_to root_url
      end
    end

    context 'when email is invalid' do
      before do
        get edit_account_activation_path(@reset_user.activation_token, email: 'wrong')
      end

      it 'redirects to root_url' do
        expect(flash[:danger]).to be_present
        expect(response).to redirect_to root_url
      end
    end

    context 'when both token and email are valid' do
      before do
        get edit_account_activation_path(@reset_user.activation_token, email: @reset_user.email)
      end

      it 'activates the user' do
        expect(@reset_user.reload.activated?).to be_truthy
      end

      it 'logs in the user' do
        expect(logged_in?).to be_truthy
      end

      it 'redirects to user page' do
        expect(flash[:success]).to be_present
        expect(response).to redirect_to user_path(@reset_user)
      end
    end

    describe 'PATCH /account_activations/:id' do
      before do
        patch account_activation_path(@reset_user.activation_token)
      end
    end
  end
end
