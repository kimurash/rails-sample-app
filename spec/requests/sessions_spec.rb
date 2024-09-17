require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'GET /login' do
    it 'returns OK' do
      get login_path
      expect(response).to have_http_status(200)
    end

    context 'with invalid information' do
      before do
        post login_path, params: { session: { email: '',
                                              password: '' } }
      end

      # 実行効率を意識して1つのテストにまとめた
      it 'renders new template with error message' do
        expect(flash[:danger]).to be_present
        expect(response).to have_http_status(422)
        expect(response).to render_template(:new)
      end
    end

    context 'with valid information' do
      let(:user) { FactoryBot.create(:michael) }

      before do
        log_in_as(user)
      end

      it 'logs in' do
        expect(response).to redirect_to user_path(user)
        # System Specではsessionメソッドが使えないためRequest Specで確認
        expect(logged_in?).to be_truthy
      end
    end

    describe 'remember me' do
      let(:user) { FactoryBot.create(:michael) }

      it 'remembers user' do
        log_in_as(user, remember_me: '1')
        expect(cookies[:remember_token]).to_not be_blank
      end

      it 'does not remember user' do
        log_in_as(user, remember_me: '0')
        expect(cookies[:remember_token]).to be_blank
      end
    end
  end

  describe 'DELETE /logout' do
    let(:user) { FactoryBot.create(:michael) }

    before do
      log_in_as(user)
    end

    it 'logs out' do
      delete logout_path
      delete logout_path
      expect(response).to have_http_status(:see_other)
      expect(response).to redirect_to root_path
      # System specではsessionメソッドが使えないためRequest Specで確認
      expect(logged_in?).to be_falsey
    end
  end
end
