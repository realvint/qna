# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    body { "My comment" }
    author

    trait :invalid do
      body { nil }
    end
  end
end
