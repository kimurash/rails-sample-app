require 'rails_helper'

RSpec.describe 'Microposts', type: :system do
  before do
    driven_by(:rack_test)
  end

  # ホームページ
  # マイクロポスト投稿フォームも含む
  describe 'home' do
    before do
      FactoryBot.send(:user_with_posts, total_posts: 35)
      @user = Micropost.first.user

      log_in_as(@user)
      visit root_path
    end

    it 'displays micropost count' do
      expect(page).to have_content "#{@user.microposts.count} microposts"
    end

    it 'displays pagination' do
      expect(page).to have_selector('div.pagination')
    end

    context 'with invalid submission' do
      before do
        fill_in 'micropost_content', with: ''
        click_button 'Post'
      end

      it 'displays error message' do
        expect(page).to have_selector('div#error_explanation')
      end

      it 'has correct pagination link' do
        expect(page).to have_selector('a[href="/?page=2"]')
      end

      it 'can attach image file' do
        expect do
          fill_in 'micropost_content', with: 'This micropost really ties the room together'
          attach_file 'micropost[image]', "#{Rails.root}/app/assets/images/kitten.jpg"
          click_button 'Post'
        end.to change(Micropost, :count).by(1)

        attached_post = Micropost.first
        expect(attached_post.image).to be_attached
      end
    end

    context 'with valid submission' do
      before do
        fill_in 'micropost_content', with: 'Lorem ipsum'
        click_button 'Post'
      end

      it 'creates a micropost' do
        expect(page).to have_content 'Micropost created!'
      end
    end
  end

  # 自身のプロフィールページ
  describe 'own profile page' do
    before do
      FactoryBot.send(:user_with_posts, total_posts: 35)
      @user = Micropost.first.user

      log_in_as(@user)
      visit user_path(@user)
    end

    it 'displays pagination' do
      pagination = find_all('div.pagination')
      expect(pagination.size).to eq(1)
    end

    it 'displays correct number of microposts' do
      posts_wrapper = within('ol.microposts') { find_all('li') }
      # paginate(per_page: 30)
      expect(posts_wrapper.size).to eq(30)
    end

    it 'displays content of microposts' do
      @user.microposts.paginate(page: 1).each do |post|
        expect(page).to have_content post.content
      end
    end

    it 'displays delete links' do
      expect(page).to have_link 'delete'
    end
  end

  # archerでログインしたときのホームページ
  describe 'lana root page' do
    let!(:micropost) { FactoryBot.create(:ants) }

    before do
      user = micropost.user
      log_in_as(user)
      visit root_path
    end

    it 'displays correct number of microposts' do
      expect(page).to have_content '1 micropost'
    end
  end

  # lanaでログインしたときのホームページ
  describe 'malory root page' do
    let(:user) { FactoryBot.create(:lana) }

    before do
      log_in_as(user)
      visit root_path
    end

    it 'displays correct number of microposts' do
      expect(page).to have_content '0 microposts'
    end
  end

  # 他人のプロフィールページ
  describe 'other user profile page' do
    let(:user) { FactoryBot.create(:michael) }
    let(:other_user) { FactoryBot.create(:archer) }

    before do
      log_in_as(user)
      visit user_path(other_user)
    end

    it 'does not display delete links' do
      expect(page).not_to have_link 'delete'
    end
  end

  # マイクロポスト削除
  describe 'DELETE /microposts/:id' do
  end
end
