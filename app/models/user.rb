# frozen_string_literal: true

class User < ApplicationRecord
  has_many :questions, foreign_key: :author_id, dependent: :destroy, inverse_of: :author
  has_many :answers, foreign_key: :author_id, dependent: :destroy, inverse_of: :author

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  def author_of?(resource)
    resource.author_id == id
  end
end
