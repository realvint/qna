# frozen_string_literal: true

require "rails_helper"

RSpec.describe Answer do
  it { is_expected.to belong_to(:question) }

  it { is_expected.to belong_to(:author) }

  it { is_expected.to have_many_attached(:files) }

  it { is_expected.to validate_presence_of :body }
end
