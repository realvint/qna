# frozen_string_literal: true

class RewardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @rewards = current_user.rewards.includes(:question).with_attached_image
  end
end
