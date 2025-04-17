# frozen_string_literal: true

require "rails_helper"

feature "User can vote for answers and questions", "
  In order to outline the most usefull answer or question
  Authenticated user can vote
" do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  describe "Authorized user" do
    describe "tries to vote for own resource" do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario "doesn't change rating of question" do
        expect(page).to have_no_css ".vote-up"
        expect(page).to have_no_css ".vote-down"
      end

      scenario "doesn't change rating of answer" do
        within ".answers" do
          expect(page).to have_no_css ".vote-up"
          expect(page).to have_no_css ".vote-down"
        end
      end
    end

    describe "vote for other's question", :js do
      background do
        sign_in(other_user)
        visit question_path(question)
      end

      scenario "changes rating up" do
        within(".question-votes") do
          find(".vote-up").click
          expect(page.find(".rating")).to have_text("1")
        end

        within(".answers") do
          find(".vote-up").click
          expect(page.find(".rating")).to have_text("1")
        end
      end

      scenario "changes rating down" do
        within(".question-votes") do
          find(".vote-down").click
          expect(page.find(".rating")).to have_text("-1")
        end

        within(".answers") do
          find(".vote-down").click
          expect(page.find(".rating")).to have_text("-1")
        end
      end
    end
  end
end
