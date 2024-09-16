require 'rails_helper'

RSpec.describe 'StaticPages', type: :system do
  before do
    driven_by(:rack_test)
  end

  describe 'root' do
    it 'has right links' do
      visit root_path
      link_to_root = page.find_all("a[href='#{root_path}']")
      expect(link_to_root.count).to eq(2)
      expect(page).to have_link 'Help', href: help_path
      expect(page).to have_link 'About', href: about_path
      expect(page).to have_link 'Contact', href: contact_path
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
