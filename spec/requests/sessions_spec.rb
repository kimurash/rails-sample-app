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

      it 'shows error message' do
        expect(response).to have_http_status(422)
        expect(response).to render_template(:new)
      end
    end

    context 'with valid information' do
      let(:user) { FactoryBot.create(:user) }

      before do
        post login_path, params: { session: { email: user.email,
                                              password: 'password' } }
      end

      it 'logs in' do
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to user_path(user)
        # System specではsessionメソッドが使えないため
        expect(logged_in?).to be_truthy
      end
    end
  end

  describe 'DELETE /logout' do
    let(:user) { FactoryBot.create(:user) }

    before do
      post login_path, params: { session: { email: user.email,
                                            password: 'password' } }
    end

    it 'logs out' do
      delete logout_path
      expect(response).to have_http_status(:see_other)
      expect(response).to redirect_to root_path
      # System specではsessionメソッドが使えないため
      expect(logged_in?).to be_falsey
    end
  end
end
