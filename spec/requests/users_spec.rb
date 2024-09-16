require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /signup' do
    it 'returns 200' do
      get signup_path
      expect(response).to have_http_status(200)
    end

    it 'has right title' do
      get signup_path
      expect(response.body).to include('Sign up')
    end
  end
end
