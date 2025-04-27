# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_comment, only: :create

  def create
    @comment =
      current_user.comments.build(
        body: comment_params[:body],
        commentable_type: params[:commentable_type],
        commentable_id: params[:commentable_id]
      )
    @comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?

    html = ApplicationController.render(
      partial: "comments/comment",
      locals: { comment: @comment }
    )

    ActionCable.server.broadcast(
      "comments",
      { html: html,
        commentable_type: @comment.commentable_type.underscore,
        commentable_id: @comment.commentable_id, user_id: @comment.author.id }
    )
  end
end
