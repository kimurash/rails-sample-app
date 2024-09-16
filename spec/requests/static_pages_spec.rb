require 'rails_helper'

RSpec.describe 'StaticPages', type: :request do
  let(:base_title) { 'Ruby on Rails Tutorial Sample App' }

  describe '#home' do
    it 'returns 200' do
      get root_path
      expect(response).to have_http_status :ok
    end

    it 'has the right title' do
      get root_path
      expect(response.body).to include "<title>#{base_title}</title>"
    end
  end

  describe '#help' do
    it 'returns 200' do
      get help_path
      expect(response).to have_http_status :ok
    end

    it 'has the right title' do
      get help_path
      expect(response.body).to include "<title>Help | #{base_title}</title>"
    end
  end

  describe '#about' do
    it 'returns 200' do
      get about_path
      expect(response).to have_http_status :ok
    end

    it 'has the right title' do
      get about_path
      expect(response.body).to include "<title>About | #{base_title}</title>"
    end
  end

  describe '#contact' do
    it 'returns 200' do
      get contact_path
      expect(response).to have_http_status :ok
    end

    it 'has the right title' do
      get contact_path
      expect(response.body).to include "<title>Contact | #{base_title}</title>"
    end
  end
end
