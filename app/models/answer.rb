# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: "User"

  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  validates :body, presence: true

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  scope :sort_by_best, -> { order(best: :desc, created_at: :desc) }

  def mark_as_best
    transaction do
      question.answers.update_all(best: false)
      update(best: true)
    end
  end
end
