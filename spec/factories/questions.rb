FactoryBot.define do
  sequence :title do |n|
    "Question title #{n}"
  end

  factory :question do
    title { 'MyString' }
    body { 'MyText' }

    trait :invalid do
      title { nil }
    end

    trait :for_list do
      title
      body { 'Question body' }
    end
  end
end
