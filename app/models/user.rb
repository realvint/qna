class User < ApplicationRecord
  has_many :questions, foreign_key: :author_id
  has_many :answers, foreign_key: :author_id

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author_of?(resource)
    resource.author_id == id
  end
end
