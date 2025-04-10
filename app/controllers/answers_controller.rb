# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: %i[update destroy delete_file]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user

    return unless @answer.save

    flash.now[:notice] = "Your answer successfully created."
  end

  def update
    @answer.update(answer_params)
    question = @answer.question
    @answers = question.answers.sort_by_best
  end

  def destroy
    return unless current_user.author_of?(@answer)

    @answer.destroy
  end

  def delete_file
    return head :forbidden unless current_user.author_of?(@answer)

    @file = @answer.files.find(params[:file_id])
    @file.purge
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end
end
