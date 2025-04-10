# frozen_string_literal: true

require "rails_helper"

RSpec.describe Question do
  it { is_expected.to belong_to(:author) }

  it { is_expected.to have_many(:answers).dependent(:destroy) }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }

  it "have many attached files" do
    expect(described_class.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
