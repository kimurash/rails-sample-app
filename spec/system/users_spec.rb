require 'rails_helper'

RSpec.describe 'Users', type: :system do
  before do
    driven_by(:rack_test)
  end

  describe '#signup' do
    it 'has right title' do
      visit signup_path
      expect(page).to have_title full_title('Sign up')
    end
  end

  describe '#new' do
    it 'has right title' do
      visit signup_path
      expect(page).to have_title full_title('Sign up')
    end
  end

  describe '#create' do
    context 'with invalid information' do
      before do
        visit signup_path
        fill_in 'Name', with: ''
        fill_in 'Email', with: 'user@invalid'
        fill_in 'Password', with: 'foo'
        fill_in 'Password confirmation', with: 'bar'
        click_button 'Create my account'
      end

      it 'shows error message' do
        expect(page).to have_selector 'div#error_explanation'
        expect(page).to have_selector 'div.alert-danger'
      end
    end

    context 'with valid information' do
      before do
        visit signup_path
        fill_in 'Name', with: 'Example User'
        fill_in 'Email', with: 'user@example.com'
        fill_in 'Password', with: 'password'
        fill_in 'Password confirmation', with: 'password'
        click_button 'Create my account'
      end

      it 'shows flash message' do
        expect(page).to have_selector 'div.alert-info'
      end
    end
  end
end
