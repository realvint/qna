# frozen_string_literal: true

module Voted
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end

  def vote
    @votable = resource_name.classify.constantize.find(params[:id])
    @votable.voting(value: params[:value], user: current_user)

    respond_to do |format|
      if current_user.author_of?(@votable)
        format.json { render json: "You can't vote for your posts", status: :unprocessable_entity }
      else
        format.json do
          render json: { id: @votable.id,
                         klass: @votable.class.to_s.underscore,
                         rating: @votable.rating,
                         status: 0 }
        end
      end
    end
  end

  private

  def resource_name
    params[:votable]
  end

  def vote_params
    params.require(:vote).permit(:value)
  end
end
