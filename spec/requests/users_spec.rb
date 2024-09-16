require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /signup' do
    it 'returns OK' do
      get signup_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /users' do
    context 'with invalid information' do
      let(:user_params) do
        {
          user: {
            name: '',
            email: 'user@invalid',
            password: 'foo',
            password_confirmation: 'bar'
          }
        }
      end

      it 'does not create a user' do
        expect { post(users_path, params: user_params) }.to_not change(User, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end
    end

    context 'with valid information' do
      let(:user_params) do
        {
          user: {
            name: 'Example User',
            email: 'user@example.com',
            password: 'password',
            password_confirmation: 'password'
          }
        }
      end

      it 'creates a user' do
        expect { post(users_path, params: user_params) }.to change(User, :count).by(1)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_url
      end
    end
  end
end
