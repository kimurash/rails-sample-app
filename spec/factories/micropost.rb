FactoryBot.define do
  factory :ants, class: Micropost do
    content { "Oh, is that what you want? Because that's how you get ants!" }
    created_at { 2.years.ago }
    user { association :archer }
  end

  factory :tone, class: Micropost do
    content { "I'm sorry. Your words made sense, but your sarcastic tone did not." }
    created_at { 10.minutes.ago }
    user { association :lana }
  end

  factory :recent_post, class: Micropost do
    content { 'Writing a short test' }
    created_at { Time.zone.now }
    user { association :michael, email: 'recent@example.com' }
  end

  factory :orange, class: Micropost do
    content { 'I just ate an orange!' }
    created_at { 10.minutes.ago }
  end
end

def user_with_posts(total_posts: 5)
  user = FactoryBot.create(:michael)
  FactoryBot.create_list(:orange, total_posts, user:)
end
