# frozen_string_literal: true

require "rails_helper"

feature "Questions author can choose best answer", "
  In order to show to community
  which answer was the most usefull author of
  question can choose the best answer
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given(:other_user) { create(:user) }
  given!(:answer) { create(:answer, question: question, author: other_user) }
  given!(:other_answer) { create(:answer, question: question, author: other_user) }

  scenario "Unauthenticated user tries to choose best answer" do
    visit question_path(question)

    expect(page).to have_no_content "Best"
  end

  describe "Authenticated user visit questions path" do
    scenario "User, who is not author tries to chose best answer" do
      sign_in(other_user)
      visit question_path(question)

      expect(page).to have_no_content "Best"
    end

    scenario "User, who is author tries to chose best answer", :js do
      sign_in(user)
      visit question_path(question)

      within("#answer-#{answer.id}") do
        click_on("Best")

        expect(page).to have_content "Best answer"
      end
    end

    scenario "User, who is author tries to change best answer", :js do
      sign_in(user)
      visit question_path(question)

      within("#answer-#{other_answer.id}") do
        click_on("Best")

        expect(page).to have_content "Best answer"
      end
    end
  end
end
