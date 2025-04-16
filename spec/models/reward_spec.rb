# frozen_string_literal: true

require "rails_helper"

RSpec.describe Reward do
  subject(:reward) { described_class.new }

  it { is_expected.to belong_to :question }
  it { is_expected.to belong_to(:answer).optional(true) }

  it { is_expected.to have_one_attached(:image) }

  it {
    expect(reward).to validate_content_type_of(:image)
      .allowing("image/png", "image/jpeg")
      .rejecting("text/plain", "text/xml")
  }

  it { is_expected.to validate_size_of(:image).less_than(1.megabyte) }

  it { is_expected.to validate_presence_of :title }
end
