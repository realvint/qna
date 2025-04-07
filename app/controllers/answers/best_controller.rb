class Answers::BestController < ApplicationController
  before_action :authenticate_user!

  def create
    answer = Answer.find(params[:answer_id])
    question = answer.question

    answer.mark_as_best if current_user.author_of?(question)
    @answers =  question.answers.sort_by_best
  end
end
