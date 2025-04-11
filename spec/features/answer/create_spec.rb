# frozen_string_literal: true

require "rails_helper"

feature "Authenticated user can answer a question", "
  In order to help to find a correct answer
  As an authenticated user
  I'd like to be able to answer the question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe "Authenticated user", :js do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario "answers a question" do
      fill_in "Body", with: "My new answer"
      click_on "Answer"

      expect(page).to have_content "Your answer successfully created."
      expect(page).to have_content "My new answer"
    end

    scenario "answers a question with errors" do
      click_on "Answer"

      expect(page).to have_content "Body can't be blank"
    end

    scenario "answer a question with attached files" do
      fill_in "Body", with: "text text text"

      attach_file "File", %W[#{Rails.root.join("spec/rails_helper.rb")} #{Rails.root.join("spec/spec_helper.rb")}]
      click_on "Answer"

      expect(page).to have_link "rails_helper.rb"
      expect(page).to have_link "spec_helper.rb"
    end
  end

  describe "Unauthenticated user" do
    scenario "tries to answer a question" do
      visit question_path(question)
      click_on "Answer"

      expect(page).to have_content "You need to sign in or sign up before continuing."
    end
  end
end
