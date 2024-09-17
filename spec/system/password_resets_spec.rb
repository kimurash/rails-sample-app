require 'rails_helper'

RSpec.describe 'PasswordResets', type: :system do
  let(:user) { FactoryBot.create(:michael) }

  before do
    driven_by(:rack_test)
  end

  describe '#new' do
    before do
      visit new_password_reset_path
    end

    it 'has right input tag' do
      expect(page).to have_selector 'input[name="password_reset[email]"]'
    end
  end

  describe '#edit' do
    before do
      user.create_reset_digest
      visit edit_password_reset_path(user.reset_token, email: user.email)
    end

    it 'has right input tag' do
      expect(page).to(
        have_selector(
          "input[name=email][type=hidden][value='#{user.email}']",
          visible: false
        )
      )
    end

    describe '#update' do
      it 'does not update with invalid password and confirmation' do
        fill_in 'Password', with: 'foobaz'
        fill_in 'Confirmation', with: 'barquux'
        click_button 'Update password'

        expect(page).to have_selector 'div#error_explanation'
      end

      it 'does not update with empty password' do
        fill_in 'Password', with: ''
        fill_in 'Confirmation', with: ''
        click_button 'Update password'

        expect(page).to have_selector 'div#error_explanation'
      end
    end
  end
end
