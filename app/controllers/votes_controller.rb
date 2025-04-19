# frozen_string_literal: true

class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    if current_user.author_of?(resource)
      return render json: { error: "You can't vote for your posts" }, status: :unprocessable_entity
    end

    resource.voting(value: params[:value], user: current_user)

    render json: {
      id: resource.id,
      klass: resource.class.to_s.underscore,
      rating: resource.rating,
      status: :ok
    }
  end

  private

  def resource
    params[:votable_type].classify.constantize.find(params[:votable_id])
  end
end
