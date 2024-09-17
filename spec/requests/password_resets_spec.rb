require 'rails_helper'

RSpec.describe 'PasswordResets', type: :request do
  let(:user) { FactoryBot.create(:michael) }

  before do
    ActionMailer::Base.deliveries.clear
  end

  describe 'GET /password_resets/new' do
    before do
      get new_password_reset_path
    end

    it 'renders the new template' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST /password_resets' do
    context 'with invalid email' do
      before do
        post password_resets_path, params: { password_reset: { email: '' } }
      end

      it 'renders the new template' do
        expect(flash[:danger]).to be_present
        expect(response).to render_template(:new)
      end
    end

    context 'with valid email' do
      before do
        post password_resets_path, params: { password_reset: { email: user.email } }
      end

      it 'redirects to root_url' do
        expect(ActionMailer::Base.deliveries.size).to eq(1)
        expect(flash[:info]).to be_present
        expect(response).to redirect_to root_url
      end
    end
  end

  describe 'GET /password_resets/edit' do
    let(:user) { FactoryBot.create(:michael) }

    before do
      post password_resets_path, params: { password_reset: { email: user.email } }
      @reset_user = controller.instance_variable_get('@user')
    end

    context 'with inactive user' do
      before do
        @reset_user.toggle!(:activated)
        get edit_password_reset_path(@reset_user.reset_token, email: @reset_user.email)
      end

      it 'redirects to root_url' do
        expect(response).to redirect_to root_url
      end
    end

    context 'with expired token' do
      before do
        @reset_user.update_attribute(:reset_sent_at, 3.hours.ago)
        get edit_password_reset_path(@reset_user.reset_token, email: @reset_user.email)
      end

      it 'redirects to the password-reset page' do
        expect(flash[:danger]).to be_present
        expect(response).to redirect_to new_password_reset_url
      end
    end

    context 'with right token & wrong email' do
      before do
        get edit_password_reset_path(@reset_user.reset_token, email: '')
      end

      it 'redirects to root_url' do
        expect(response).to redirect_to root_url
      end
    end

    context 'with right email & wrong token' do
      before do
        get edit_password_reset_path('wrong token', email: @reset_user.email)
      end

      it 'redirects to root_url' do
        expect(response).to redirect_to root_url
      end
    end

    context 'with right email & right token' do
      before do
        get edit_password_reset_path(@reset_user.reset_token, email: @reset_user.email)
      end

      it 'renders the edit template' do
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'PATCH /password_resets' do
    before do
      post password_resets_path, params: { password_reset: { email: user.email } }
      @reset_user = controller.instance_variable_get('@user')
    end

    context 'with expired token' do
      before do
        @reset_user.update_attribute(:reset_sent_at, 3.hours.ago)
        patch(
          password_reset_path(@reset_user.reset_token),
          params: {
            email: @reset_user.email,
            user: { password: 'foobar', password_confirmation: 'foobar' }
          }
        )
      end

      it 'redirects to the password-reset page' do
        expect(flash[:danger]).to be_present
        expect(response).to redirect_to new_password_reset_url
      end
    end

    context 'with valid password & confirmation' do
      before do
        patch(
          password_reset_path(@reset_user.reset_token),
          params: {
            email: @reset_user.email,
            user: { password: 'foobaz', password_confirmation: 'foobaz' }
          }
        )
      end

      it 'updates password' do
        expect(logged_in?).to be_truthy
        expect(@reset_user.reload.reset_digest).to be_nil
        expect(flash[:success]).to be_present
        expect(response).to redirect_to user_path(@reset_user)
      end
    end
  end
end
