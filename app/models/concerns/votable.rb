# frozen_string_literal: true

module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy

    def voting(value:, user:)
      vote = votes.find_or_initialize_by(user: user)

      if vote.persisted?
        if vote.value == value.to_i
          vote.destroy
        else
          vote.update(value: value)
        end
      else
        vote.value = value
        vote.save
      end
    end

    def rating
      votes.sum(:value)
    end
  end
end
