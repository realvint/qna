# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    value { 0 }
    user { nil }
  end
end
