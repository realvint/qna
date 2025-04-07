require 'rails_helper'

feature "User can edit his answer", %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
  } do

  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: user) }

  scenario "Unauthenticated user can not edit answer" do
    visit question_path(question)

    expect(page).to_not have_link "Edit"
  end

  describe "Authenticated user", js: true do
    scenario "edits his answer" do
      sign_in(user)
      visit question_path(question)

      click_on "Edit"

      within ".answers" do
        fill_in "Your answer", with: "Edited answer"
        click_on "Save"

        expect(page).to_not have_content answer.body
        expect(page).to have_content "Edited answer"
        expect(page).to_not have_selector "textarea[name='answer[body]']"
      end
    end

    scenario "edits his answer with errors" do
      sign_in(user)

      visit question_path(question)

      click_on "Edit"

      within ".answers" do
        fill_in "Your answer", with: ""
        click_on "Save"
      end
      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's answer" do
      sign_in(other_user)

      visit question_path(question)

      expect(page).to_not have_link "Edit"
    end
  end
end
