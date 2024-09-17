require 'rails_helper'

RSpec.describe 'Sessions', type: :system do
  before do
    driven_by(:rack_test)
  end

  describe '#create' do
    let(:user) { FactoryBot.create(:michael) }

    context 'with invalid information' do
      before do
        log_in_as(user, password: 'invalid')
      end

      it 'shows error message' do
        expect(page).to have_selector 'div.alert-danger'

        visit root_path
        expect(page).not_to have_selector 'div.alert-danger'
      end
    end

    context 'with valid information' do
      before do
        log_in_as(user)
      end

      it 'has right links' do
        expect(page).not_to have_link 'Log in', href: login_path
        expect(page).to have_link 'Log out', href: logout_path
        expect(page).to have_link 'Profile', href: user_path(user)
      end
    end
  end

  describe '#destroy' do
    let(:user) { FactoryBot.create(:michael) }

    before do
      log_in_as(user)
      click_link 'Log out'
    end

    it 'has right links' do
      expect(page).to have_link 'Log in', href: login_path
      expect(page).not_to have_link 'Log out', href: logout_path
      expect(page).not_to have_link 'Profile', href: user_path(user)
    end
  end
end
