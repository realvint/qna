# frozen_string_literal: true

require "rails_helper"

feature "Author can delete his answer", "
  In order to give correct information
  As an authenticated user and author of an answer
  I'd like to be able to delete my answer
" do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:answer) { create(:answer, author: user) }

  background do
    answer.files.attach(io: File.open(Rails.root.join("spec/rails_helper.rb").to_s), filename: "rails_helper.rb")
  end

  describe "An author of the answer", :js do
    background do
      sign_in(user)
      visit question_path(answer.question)
    end

    scenario "deletes it" do
      click_on "Delete"

      accept_alert "Are you sure?"

      expect(page).to have_no_content answer.body
    end

    scenario "can delete attached file" do
      expect(page).to have_link "rails_helper.rb"
      expect(page).to have_link "Delete file"

      click_on "Delete file"

      expect(page).to have_no_link "rails_helper.rb"
    end
  end

  describe "Not an author of the answer" do
    background do
      sign_in(other_user)
      visit question_path(answer.question)
    end

    scenario "cannot delete an answer" do
      expect(page).to have_content "My answer"
      expect(page).to have_no_link("Delete")
    end

    scenario "cannot delete attached file" do
      expect(page).to have_link "rails_helper.rb"
      expect(page).to have_no_link "Delete file"
    end
  end

  scenario "Unauthenticated user cannot delete answers" do
    visit question_path(answer.question)

    expect(page).to have_content "My answer"
    expect(page).to have_no_link("Delete")
  end
end
