FactoryBot.define do
  factory :quiz do
    user
    title Faker::Name.title
    question "<p>#{Faker::Lorem.sentence}</p>"
    correct_answer Faker::Name.title
    explanation "<p>#{Faker::Lorem.sentence}</p>"
  end

  factory :multi_answer_quiz, class: Quiz do
    user
    title Faker::Name.title
    question "<p>#{Faker::Lorem.sentence}</p>"
    multi_answers_json [Faker::Name.title, Faker::Name.title, Faker::Name.title].to_json
    explanation "<p>#{Faker::Lorem.sentence}</p>"
  end
end
