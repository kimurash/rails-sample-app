require 'rails_helper'

RSpec.describe 'Sessions', type: :system do
  before do
    driven_by(:rack_test)
  end

  describe '#create' do
    let(:user) { FactoryBot.create(:user) }

    context 'with invalid information' do
      before do
        visit login_path
        fill_in 'Email', with: user.email
        fill_in 'Password', with: 'invalid'
        click_button 'Log in'
      end

      it 'shows error message' do
        expect(page).to have_selector 'div.alert-danger'

        visit root_path
        expect(page).not_to have_selector 'div.alert-danger'
      end
    end

    context 'with valid information' do
      before do
        visit login_path
        fill_in 'Email', with: user.email
        fill_in 'Password', with: 'password'
        click_button 'Log in'
      end

      it 'has right links' do
        expect(page).not_to have_link 'Log in', href: login_path
        expect(page).to have_link 'Log out', href: logout_path
        expect(page).to have_link 'Profile', href: user_path(user)
      end
    end
  end
end
