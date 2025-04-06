require 'rails_helper'

feature "User can edit his question", %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
  } do

  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  scenario "Unauthenticated user can not edit answer" do
    visit questions_path

    expect(page).to_not have_link "Edit"
  end

  describe "Authenticated user", js: true do
    scenario "edits his question" do
      sign_in(user)
      visit questions_path

      click_on "Edit"

      within "#question-#{question.id}" do
        fill_in "Title", with: "Edited question"
        click_on "Save"

        expect(page).to_not have_content question.title
        expect(page).to have_content "Edited question"
        expect(page).to_not have_selector "input[name='question[title]']"
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

    scenario "tries to edit other user's question" do
      sign_in(other_user)

      visit questions_path

      expect(page).to_not have_link "Edit"
    end
  end
end
