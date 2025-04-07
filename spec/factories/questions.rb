# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    sequence :title do |n|
      "Question title#{n}"
    end
    sequence :body do |n|
      "Question body#{n}"
    end

    trait :invalid do
      title { nil }
    end

    author
  end
end
