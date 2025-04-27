# frozen_string_literal: true

require "rails_helper"

RSpec.describe CommentsController do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe "Authenticated user" do
    before { login(user) }

    context "with valid attributes" do
      it "creates new comment for question" do
        expect do
          post :create,
            params: { comment: { body: "Comment" },
                      commentable_id: question.id, commentable_type: question.class.name }, format: :js
        end.to change(question.comments, :count).by(1)
      end

      it "renders create view" do
        post :create,
          params: { comment: { body: "Comment" },
                    commentable_id: question.id, commentable_type: question.class.name }, format: :js
        expect(response).to render_template :create
      end
    end

    context "with invalid attributes" do
      it "doesn't save comment" do
        expect do
          post :create,
            params: { comment: { body: "" },
                      commentable_id: question.id, commentable_type: question.class.name }, format: :js
        end.not_to change(question.comments, :count)
      end

      it "renders create view" do
        post :create,
          params: { comment: { body: "" }, commentable_id: question.id,
                    commentable_type: question.class.name }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe "Unauthenticated user" do
    it "doesn't save comment" do
      expect do
        post :create,
          params: { comment: { body: "Comment" },
                    commentable_id: question.id, commentable_type: question.class.name }, format: :js
      end.not_to change(question.comments, :count)
    end
  end
end
