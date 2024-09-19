require 'rails_helper'

RSpec.describe 'Users', type: :system do
  before do
    driven_by(:rack_test)
  end

  # ユーザ登録ページの取得
  describe '#signup' do
    it 'has right title' do
      visit signup_path
      expect(page).to have_title full_title('Sign up')
    end
  end

  # ユーザ一覧ページの取得
  describe '#index' do
    let!(:admin) { FactoryBot.create(:michael) }
    let!(:non_admin) { FactoryBot.create(:archer) }
    let(:inactive_user) { FactoryBot.create(:malory) }

    context 'when logged in as non-admin user' do
      before do
        log_in_as(non_admin)
        visit users_path
      end

      it 'does not include inactive users' do
        expect(page).not_to have_link inactive_user.name, href: user_path(inactive_user)
      end

      it 'does not have delete links' do
        expect(page).not_to have_link 'delete'
      end
    end

    context 'when logged in as admin user' do
      before do
        # ここでユーザを作成するべきかは検討の余地あり
        30.times do
          FactoryBot.create(:seq_users)
        end
        log_in_as(admin)
        visit users_path
      end

      it 'has pagination' do
        expect(page).to have_selector 'div.pagination'
        User.paginate(page: 1).each do |user|
          expect(page).to have_link user.name, href: user_path(user)
          # 実行効率を意識して削除リンクの有無も同じexampleでテスト
          expect(page).to have_link 'delete', href: user_path(user) if user != admin
        end
      end
    end
  end

  # ユーザ登録ページの取得
  describe '#new' do
    it 'has right title' do
      visit signup_path
      expect(page).to have_title full_title('Sign up')
    end
  end

  # ユーザ登録
  describe '#create' do
    context 'with invalid information' do
      before do
        visit signup_path
        fill_in 'Name', with: ''
        fill_in 'Email', with: 'user@invalid'
        fill_in 'Password', with: 'foo'
        fill_in 'Confirmation', with: 'bar'
        click_button 'Create my account'
      end

      it 'shows error message' do
        expect(page).to have_selector 'div#error_explanation'
        expect(page).to have_selector 'div.alert-danger'
      end
    end
  end

  describe '#show' do
    let(:user) { FactoryBot.create(:michael) }

    before do
      log_in_as(user)
    end

    context 'without following & followers' do
      before do
        visit user_path(user)
      end

      it 'has right content' do
        expect(page).to have_title full_title(user.name)
        expect(page).to have_selector 'h1', text: user.name
        expect(page).to have_selector 'h1>img.gravatar'
      end
    end

    context 'with following & followers' do
      before do
        user = FactoryBot.send(:create_relationships)
        visit user_path(user)
      end

      it 'displays following & followers count' do
        expect(page).to have_content '10 following'
        expect(page).to have_content '10 followers'
      end
    end
  end

  # ユーザ情報の編集
  describe '#update' do
    let(:user) { FactoryBot.create(:michael) }

    context 'when not logged in' do
      before do
        visit edit_user_path(user)
      end

      it 'shows error message' do
        expect(page).to have_selector 'div.alert-danger'
      end
    end

    context 'when logged in' do
      before do
        log_in_as(user)
      end

      context 'with invalid information' do
        before do
          visit edit_user_path(user)
          fill_in 'Name', with: ''
          fill_in 'Email', with: 'user@invalid'
          fill_in 'Password', with: 'foo'
          fill_in 'Confirmation', with: 'bar'
          click_button 'Save changes'
        end

        it 'shows 4 error messages' do
          expect(page).to have_selector 'div#error_explanation'
          expect(page).to have_selector 'div.alert-danger'
          expect(page).to have_content 'The form contains 4 errors.'
        end
      end
    end
  end

  describe '#following' do
    let(:user) { FactoryBot.send(:create_relationships) }

    before do
      log_in_as(user)
      visit following_user_path(user)
    end

    it 'displays following users' do
      expect(page).to have_http_status(:success)

      expect(page).to have_content user.following.count.to_s
      user.following.each do |followed|
        expect(page).to have_link followed.name, href: user_path(followed)
      end
    end
  end

  describe '#followers' do
    let(:user) { FactoryBot.send(:create_relationships) }

    before do
      log_in_as(user)
      visit followers_user_path(user)
    end

    it 'displays followers' do
      expect(page).to have_http_status(:success)

      expect(page).to have_content user.followers.count.to_s
      user.followers.each do |follower|
        expect(page).to have_link follower.name, href: user_path(follower)
      end
    end
  end
end
