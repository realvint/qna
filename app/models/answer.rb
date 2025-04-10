# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: "User"

  validates :body, presence: true

  scope :sort_by_best, -> { order(best: :desc, created_at: :desc) }

  def mark_as_best
    transaction do
      question.answers.update_all(best: false)
      update(best: true)
    end
  end
end
