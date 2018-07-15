FactoryBot.define do
  factory :quiz do
    user
    title Faker::Name.title
    question "<p>#{Faker::Lorem.sentence}</p>"
    correct_answer Faker::Name.title
    explanation "<p>#{Faker::Lorem.sentence}</p>"
  end
end
