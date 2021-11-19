class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user

    if @answer.save
      redirect_to @answer.question, notice: 'Your answer successfully created.'
    else
      render 'questions/show'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])

    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to questions_path, notice: 'Your answer was deleted.'
    else
      flash[:notice] = 'Action not allowed'
      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
