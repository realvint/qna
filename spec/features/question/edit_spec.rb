# frozen_string_literal: true

require "rails_helper"

feature "User can edit his question", "
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
  " do
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  scenario "Unauthenticated user can not edit answer" do
    visit questions_path

    expect(page).to have_no_link "Edit"
  end

  describe "Authenticated user", :js do
    scenario "edits his question" do
      sign_in(user)
      visit questions_path

      click_on "Edit"

      within "#question-#{question.id}" do
        fill_in "Title", with: "Edited question"
        click_on "Save"

        expect(page).to have_no_content question.title
        expect(page).to have_content "Edited question"
        expect(page).to have_no_css "input[name='question[title]']"
      end
    end

    scenario "edits his question with errors" do
      sign_in(user)

      visit questions_path

      click_on "Edit"

      within "#question-#{question.id}" do
        fill_in "Title", with: ""
        click_on "Save"
      end
      expect(page).to have_content "Title can't be blank"
    end

    scenario "edits his question and attach files" do
      sign_in(user)
      visit questions_path

      click_on "Edit"

      within "#question-#{question.id}" do
        fill_in "Title", with: "Edited question"

        attach_file "File", %W[#{Rails.root.join("spec/rails_helper.rb")} #{Rails.root.join("spec/spec_helper.rb")}]

        click_on "Save"

        expect(page).to have_no_content question.title
        expect(page).to have_content "Edited question"
        expect(page).to have_no_css "input[name='question[title]']"
      end

      visit question_path(question)

      expect(page).to have_link "rails_helper.rb"
      expect(page).to have_link "spec_helper.rb"
    end

    scenario "tries to edit other user's question" do
      sign_in(other_user)

      visit questions_path

      expect(page).to have_no_link "Edit"
    end
  end
end
