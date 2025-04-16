# frozen_string_literal: true

require "rails_helper"

feature "User can delete links of question", "{
  In order to change additional info to my question
  As an question's author
  I'd like to be able to delete links
}" do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:link) { create(:link, linkable: question) }

  scenario "User deletes link of his question", :js do
    sign_in(user)
    visit questions_path

    within "#question-#{question.id}" do
      click_link "Edit"
      click_link "Remove link"
      click_button "Save"
    end

    visit question_path(question)
    expect(page).to have_no_link link.name, href: link.url
  end
end
