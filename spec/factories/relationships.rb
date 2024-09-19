FactoryBot.define do
  factory :follower, class: Relationship do
    # follower_idとfollowed_idは引数で置き換える
    follower_id { 1 }
    followed_id { 1 }
  end

  factory :following, class: Relationship do
    follower_id { 1 }
    followed_id { 1 }
  end
end

def create_relationships
  10.times do
    FactoryBot.create(:seq_users)
  end

  user = User.find_by(email: 'michael@example.com')
  user = FactoryBot.create(:michael) if user.nil?

  # michael以外の全ユーザーを相互フォローする
  User.all.each do |other|
    if user != other
      FactoryBot.create(:follower,  follower_id: other.id, followed_id: user.id)
      FactoryBot.create(:following, follower_id: user.id,  followed_id: other.id)
    end
  end
  user
end
