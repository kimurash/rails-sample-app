require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) do
    User.new(
      name: 'Example User',
      email: 'user@example.com',
      password: 'foobar',
      password_confirmation: 'foobar'
    )
  end

  it 'should be valid' do
    expect(user).to be_valid
  end

  # ======= ユーザ名 =======

  it 'name should be present' do
    user.name = ''
    expect(user).not_to be_valid
  end

  it 'name should not be longer than 50' do
    user.name = 'a' * 51
    expect(user).not_to be_valid
  end

  # ======= メールアドレス =======

  it 'email should be present' do
    user.email = ''
    expect(user).not_to be_valid
  end

  it 'email should not be longer than 255' do
    user.email = 'a' * 244 + '@example.com'
    expect(user).not_to be_valid
  end

  it 'email validation should accept valid addresses' do
    valid_addresses = %w[
      user@example.com
      USER@foo.COM
      A_US-ER@foo.bar.org
      first.last@foo.jp alice+bob@baz.cn
    ]
    valid_addresses.each do |valid_address|
      user.email = valid_address
      expect(user).to be_valid
    end
  end

  it 'email validation should reject invalid addresses' do
    invalid_addresses = %w[
      user@example,com
      user_at_foo.org
      user.name@example.
      foo@bar_baz.com
      foo@bar+baz.com
      foo@bar..com
    ]
    invalid_addresses.each do |invalid_address|
      user.email = invalid_address
      expect(user).not_to be_valid
    end
  end

  it 'email addresses should be unique' do
    dup_user = user.dup
    user.save
    expect(dup_user).not_to be_valid
  end

  it 'email addresses should be saved as lower-case' do
    mixed_case_email = 'Foo@ExAMPle.CoM'
    user.email = mixed_case_email
    user.save
    expect(user.reload.email).to eq mixed_case_email.downcase
  end

  # ======= パスワード =======

  it 'password should be present (nonblank)' do
    user.password = user.password_confirmation = ' ' * 6
    expect(user).not_to be_valid
  end

  it 'password should be longer than 5' do
    user.password = user.password_confirmation = 'a' * 5
    expect(user).not_to be_valid
  end

  describe 'authenticated?' do
    it 'should return false for a user with nil digest' do
      expect(user.authenticated?(:remember, '')).to be false
    end
  end

  # ======= フォロー&フォロー解除 =======

  describe 'follow and unfollow' do
    let(:michael) { FactoryBot.create(:michael) }
    let(:archer) { FactoryBot.create(:archer) }

    it 'follow and unfollow user' do
      expect(michael.following?(archer)).to be false
      michael.follow(archer)
      expect(michael.following?(archer)).to be true
      expect(archer.followers.include?(michael)).to be true
      michael.unfollow(archer)
      expect(michael.following?(archer)).to be false
    end
  end

  # ======= フィード =======

  describe 'feed' do
    let(:michael) { FactoryBot.create(:michael) }
    let(:archer) { FactoryBot.create(:archer) }
    let(:lana) { FactoryBot.create(:lana) }

    let(:post_by_michael) { FactoryBot.create(:recent_post) }
    let(:post_by_archer) { FactoryBot.create(:ants) }
    let(:post_by_lana) { FactoryBot.create(:tone) }

    before do
      michael.follow(archer)
    end

    it 'should have the right posts' do
      # 自分自身の投稿
      michael.microposts.each do |own_post|
        expect(michael.feed.include?(own_post)).to be true
      end

      # フォローしているユーザの投稿
      archer.microposts.each do |following_post|
        expect(michael.feed.include?(following_post)).to be true
      end

      # フォローしていないユーザの投稿
      lana.microposts.each do |unfollowed_post|
        expect(michael.feed.include?(unfollowed_post)).to be false
      end
    end
  end
end
