# frozen_string_literal: true

require "rails_helper"

feature "User can edit links of question", "{
  In order to change additional info to my question
  As an question's author
  I'd like to be able to edit links
}" do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:link) { create(:link, linkable: question) }
  given(:ya_url) { "https://ya.ru" }

  scenario "User edits link of his question", :js do
    sign_in(user)
    visit questions_path

    within "#question-#{question.id}" do
      click_link "Edit"
      fill_in "Link name", with: "My link"
      fill_in "Url", with: ya_url
      click_button "Save"
    end
    visit question_path(question)
    expect(page).to have_link "My link", href: ya_url
  end
end
