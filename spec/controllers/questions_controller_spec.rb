# frozen_string_literal: true

require "rails_helper"

RSpec.describe QuestionsController do
  let(:question) { create(:question, author: user) }
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe "GET #index" do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it "populate an array of all questions" do
      expect(assigns(:questions)).to match_array(questions)
    end

    it "renders index view" do
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    before { get :show, params: { id: question } }

    it "assigns the requested question to @question" do
      expect(assigns(:question)).to eq question
    end

    it "renders show view" do
      expect(response).to render_template :show
    end

    it "assigns a new answer to @answer" do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it "assigns new link for answer" do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end
  end

  describe "GET #new" do
    before do
      login(user)
      get :new
    end

    it "assigns a new Question to @question" do
      expect(assigns(:question)).to be_a_new(Question)
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it "renders new view" do
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    before { login(user) }

    context "with valid attributes" do
      it "saves a new question in database" do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it "redirects to show view" do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context "with invalid attributes" do
      it "does not save the question" do
        expect do
          post :create, params: { question: attributes_for(:question, :invalid) }
        end.not_to change(Question, :count)
      end

      it "re-renders new view" do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe "PATCH #update" do
    before { login(user) }

    context "with valid attributes" do
      it "changes question attributes" do
        patch :update, params: { id: question, question: { title: "new title" } }, format: :js
        question.reload
        expect(question.title).to eq "new title"
      end

      it "renders update template" do
        patch :update, params: { id: question, question: { title: "new title" } }, format: :js
        expect(response).to render_template :update
      end
    end

    context "with invalid attributes" do
      it "does not change question attributes" do
        expect do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        end.not_to change(question, :title)
      end

      it "renders update template" do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:question) { create(:question, author: user) }

    context "Authenticated user, the author of the question" do
      before { login(user) }

      it "can delete the question" do
        expect { delete :destroy, params: { id: question }, format: :js }.to change(Question, :count).by(-1)
      end

      it "has no redirects to index after destroy" do
        delete :destroy, params: { id: question }, format: :js
        expect(response).not_to redirect_to questions_path
      end
    end

    context "Authenticated user, not author of the question" do
      before { login(other_user) }

      it "can not delete the question" do
        expect { delete :destroy, params: { id: question }, format: :js }.not_to change(Question, :count)
      end

      it "no renders question page" do
        delete :destroy, params: { id: question }, format: :js

        expect(response).not_to render_template :show
      end
    end
  end
end
