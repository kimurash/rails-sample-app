require 'rails_helper'

RSpec.describe 'StaticPages', type: :request do
  let(:base_title) { 'Ruby on Rails Tutorial Sample App' }

  describe 'GET /' do
    it 'returns OK' do
      get root_path
      expect(response).to have_http_status :ok
    end
  end

  describe 'GET /help' do
    it 'returns OK' do
      get help_path
      expect(response).to have_http_status :ok
    end
  end

  describe 'GET /about' do
    it 'returns OK' do
      get about_path
      expect(response).to have_http_status :ok
    end
  end

  describe 'GET /contact' do
    it 'returns OK' do
      get contact_path
      expect(response).to have_http_status :ok
    end
  end
end
