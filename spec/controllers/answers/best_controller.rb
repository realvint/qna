require 'rails_helper'

RSpec.describe Answers::BestController, type: :controller do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let!(:answer) { create(:answer, question: question, author: user) }
  let!(:other_answer) { create(:answer, question: question, author: other_user) }

  describe 'POST #create' do
    context 'Author of question' do
      before { login(user) }

      it 'marks the selected answer as best' do
        post :create, params: { answer_id: other_answer.id }, format: :js
        expect(other_answer.reload).to be_best
      end

      it 'unmarks previously best answer' do
        answer.update!(best: true)

        post :create, params: { answer_id: other_answer.id }, format: :js

        expect(answer.reload).not_to be_best
        expect(other_answer.reload).to be_best
      end

      it 'renders create template' do
        post :create, params: { answer_id: other_answer.id }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'Not author of question' do
      before { login(other_user) }

      it 'does not mark answer as best' do
        post :create, params: { answer_id: other_answer.id }, format: :js
        expect(other_answer.reload).not_to be_best
      end
    end
  end
end
