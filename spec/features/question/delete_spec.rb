# frozen_string_literal: true

require "rails_helper"

feature "Only author can delete his question", "
  In order to express one's opinion
  As an authenticated user and author of question
  I'd like to be to delete my question
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:other_user) { create(:user) }

  describe "An author of the question" do
    background do
      sign_in(user)
      visit questions_path
    end

    scenario "deletes it", :js do
      click_on "Delete"

      accept_alert "Are you sure?"

      expect(page).to have_no_content question.title
    end

    scenario "can delete attached file", :js do
      question.files.attach(io: File.open(Rails.root.join("spec/rails_helper.rb").to_s), filename: "rails_helper.rb")

      visit question_path(question)

      expect(page).to have_link "rails_helper.rb"
      expect(page).to have_link "Delete file"

      click_on "Delete file"

      expect(page).to have_no_link "rails_helper.rb"
    end
  end

  describe "Not an author of the question" do
    background do
      sign_in(other_user)
      visit questions_path
    end

    scenario "cannot delete a question" do
      question.files.attach(io: File.open(Rails.root.join("spec/rails_helper.rb").to_s), filename: "rails_helper.rb")

      expect(page).to have_no_link "Delete"
    end

    scenario "cannot delete attached file" do
      expect(page).to have_no_link "Delete file"
    end
  end

  scenario "Unauthenticated user cannot delete question" do
    visit questions_path

    expect(page).to have_no_link "Delete"
  end
end
