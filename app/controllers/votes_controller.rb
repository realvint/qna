# frozen_string_literal: true

class VotesController < ApplicationController
  ALLOWED_VOTABLES = {
    "question" => Question,
    "answer" => Answer
  }.freeze

  before_action :authenticate_user!
  before_action :set_resource

  def create
    if current_user.author_of?(@resource)
      return render json: { error: "You can't vote for your posts" }, status: :unprocessable_entity
    end

    @resource.voting(value: params[:value], user: current_user)

    render json: {
      id: @resource.id,
      klass: @resource.class.to_s.underscore,
      rating: @resource.rating,
      status: :ok
    }
  end

  private

  def set_resource
    klass = ALLOWED_VOTABLES[params[:votable_type]]

    return render json: { error: "Invalid votable type" }, status: :unprocessable_entity unless klass

    @resource = klass.find_by(id: params["#{votable_type.singularize}_id"])

    return if @resource

    render json: { error: "#{klass} with id #{votable_id} not found" }, status: :not_found
  end
end
