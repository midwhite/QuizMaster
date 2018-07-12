FactoryBot.define do
  factory :user do
    name Faker::Name.name
    email Faker::Internet.email
    password Faker::Internet.password
    birthday Faker::Date.birthday
    profile Faker::Lorem.sentence
    access_token { "#{id}:#{Devise.friendly_token}" }
  end
end
