require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:user) { FactoryBot.create(:michael) }
  let(:micropost) { user.microposts.build(content: 'Lorem ipsum') }

  it 'is valid' do
    expect(micropost).to be_valid
  end

  # ======= ユーザID =======

  it 'user id should be present' do
    micropost.user_id = nil
    expect(micropost).to_not be_valid
  end

  # ======= 本文 =======

  it 'content should be present' do
    micropost.content = ' '
    expect(micropost).to_not be_valid
  end

  it 'content should be less than 140 characters' do
    micropost.content = 'a' * 141
    expect(micropost).to_not be_valid
  end

  # ======= マイクロポストの順序 =======
  it 'order should be most recent first' do
    FactoryBot.send(:user_with_posts)
    recent_post = FactoryBot.create(:recent_post)
    expect(recent_post).to eq Micropost.first
  end

  it 'destroys associated microposts' do
    post = FactoryBot.create(:recent_post)
    user = post.user
    expect { user.destroy }.to change(Micropost, :count).by(-1)
  end
end
