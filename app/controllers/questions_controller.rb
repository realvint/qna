# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show update destroy]

  after_action :publish_question, only: %i[create]

  def index
    @questions = Question.order(created_at: :desc)
  end

  def show
    @answer = Answer.new
    @answer.links.build
    @answers = @question.answers.with_attached_files.sort_by_best
  end

  def new
    @question = Question.new
    @question.links.build
    @reward = Reward.new(question: @question)
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: "Your question successfully created."
    else
      render :new
    end
  end

  def update
    @question.update(question_params) if current_user.author_of?(@question)
  end

  def destroy
    @question.destroy if current_user.author_of?(@question)
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(
      :title,
      :body,
      files: [],
      links_attributes: %i[id name url _destroy],
      reward_attributes: %i[title image]
    )
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast("questions", { html: ApplicationController.render(
      partial: "questions/question",
      locals: { question: @question }
    ) })
  end
end
