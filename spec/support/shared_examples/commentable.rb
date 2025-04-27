# frozen_string_literal: true

RSpec.shared_examples "commentable" do
  it { is_expected.to have_many(:comments).dependent(:destroy) }
end
