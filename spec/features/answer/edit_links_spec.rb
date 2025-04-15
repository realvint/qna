# frozen_string_literal: true

require "rails_helper"

feature "User can edit links of answer", "{
  In order to change additional info to my answer
  As an answer's author
  I'd like to be able to edit links
}" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given!(:link) { create(:link, linkable: answer) }
  given(:ya_url) { "https://ya.ru" }

  scenario "User edits link of his question", :js do
    sign_in(user)
    visit question_path(question)

    within "#answer-#{answer.id}" do
      click_link "Edit"
      fill_in "Link name", with: "My link"
      fill_in "Url", with: ya_url
      click_on "Save"
    end

    expect(page).to have_link "My link", href: ya_url
  end
end
