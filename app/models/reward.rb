# frozen_string_literal: true

class Reward < ApplicationRecord
  belongs_to :question
  belongs_to :answer, optional: true

  has_one_attached :image

  validates :title, presence: true
  validates :image, attached: true, content_type: %w[image/png image/jpeg], size: { less_than: 1.megabyte }
end
