# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :author, class_name: "User"

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy

  has_many_attached :files

  validates :title, :body, presence: true

  accepts_nested_attributes_for :links, reject_if: :all_blank
end
