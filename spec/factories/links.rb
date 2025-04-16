# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    name { "My gist" }
    url { "https://gist.github.com" }
  end
end
