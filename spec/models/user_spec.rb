# frozen_string_literal: true

require "rails_helper"

RSpec.describe User do
  it { is_expected.to have_many(:questions) }
  it { is_expected.to have_many(:answers) }
  it { is_expected.to have_many(:rewards).dependent(:destroy) }

  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }

  describe "Check an author_of?(resource)" do
    let(:author) { create(:user) }
    let(:user) { create(:user) }
    let(:question) { create(:question, author: author) }

    it "User is author" do
      expect(author).to be_author_of(question)
    end

    it "User is not author" do
      expect(user).not_to be_author_of(question)
    end
  end
end
