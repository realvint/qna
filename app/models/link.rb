# frozen_string_literal: true

class Link < ApplicationRecord
  validates :name, :url, presence: true
  validates :url, url: true

  belongs_to :question
end
