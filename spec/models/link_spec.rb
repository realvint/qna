# frozen_string_literal: true

require "rails_helper"

RSpec.describe Link do
  it { is_expected.to belong_to :linkable }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :url }

  describe "#gist?" do
    it "returns true for a GitHub gist url" do
      link = described_class.new(url: "https://gist.github.com")
      expect(link).to be_gist
    end

    it "returns false for a non-gist url" do
      link = described_class.new(url: "https://ya.ru")
      expect(link).not_to be_gist
    end
  end
end
