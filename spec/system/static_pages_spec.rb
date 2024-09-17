require 'rails_helper'

RSpec.describe 'StaticPages', type: :system do
  before do
    driven_by(:rack_test)
  end

  describe 'root' do
    context 'when not logged in' do
      before do
        visit root_path
      end

      it 'has right links' do
        link_to_root = page.find_all("a[href='#{root_path}']")
        expect(link_to_root.count).to eq(2)
        expect(page).to have_link 'Help', href: help_path
        expect(page).to have_link 'About', href: about_path
        expect(page).to have_link 'Contact', href: contact_path
      end
    end

    context 'when logged in' do
      let!(:user) { FactoryBot.create(:archer) }

      before do
        log_in_as(user)
        visit root_path
      end

      it 'has right links' do
        expect(page).to have_link 'Users', href: users_path
        expect(page).to have_link 'Profile', href: user_path(user)
        expect(page).to have_link 'Settings', href: edit_user_path(user)
        expect(page).to have_link 'Log out', href: logout_path

        expect(page).to have_link "#{user.following.count} following", href: following_user_path(user)
        expect(page).to have_link "#{user.followers.count} followers", href: followers_user_path(user)

        # expect(page).to have_selector 'div.stats'
        # expect(page).to have_selector '#following', text: @user.following.count
        # expect(page).to have_selector '#followers', text: @user.followers.count
      end
    end
  end

  describe 'help' do
    it 'has right title' do
      visit help_path
      expect(page).to have_title full_title('Help')
    end
  end

  describe 'about' do
    it 'has right title' do
      visit about_path
      expect(page).to have_title full_title('About')
    end
  end

  describe 'contact' do
    it 'has right title' do
      visit contact_path
      expect(page).to have_title full_title('Contact')
    end
  end
end
