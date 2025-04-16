# frozen_string_literal: true

require "rails_helper"

feature "The author of the question can assign an award for the best answer", "
  In order to outline the best answer to the question,
  As an author of the question,
  user is able to assign a reward for the best answer
" do
  given(:user) { create(:user) }

  describe "Authenticated user", :js do
    background do
      sign_in(user)
      visit new_question_path

      within ".question-fields" do
        fill_in "Title", with: "Test question"
        fill_in "Body", with: "text text text"
      end

      within ".reward-fields" do
        fill_in "Title", with: "First Reward"
        attach_file "Image", Rails.root.join("spec/files/reward.png").to_s
      end

      click_on "Ask"
    end

    scenario "adds reward to question" do
      expect(page).to have_content "Your question successfully created."
      expect(page).to have_content "First Reward"
      expect(page).to have_css("img[src*='class.png']")
    end

    scenario "assign reward for the author of the best answer", :js do
      fill_in "Body", with: "My new answer"
      click_on "Answer"

      click_on "Best"

      visit rewards_path

      expect(page).to have_content "First Reward"
      expect(page).to have_content "Test question"
      expect(page).to have_css("img[src*='class.png']")
    end
  end
end
