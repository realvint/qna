FactoryBot.define do
  factory :answer do
    body { 'My answer' }
    question
    author

    trait :invalid do
      body { nil }
    end
  end
end
