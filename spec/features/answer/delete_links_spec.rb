# frozen_string_literal: true

require "rails_helper"

feature "User can delete links of answer", "{
  In order to change additional info to my answer
  As an answer's author
  I'd like to be able to delete links
}" do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given!(:link) { create(:link, linkable: answer) }

  scenario "User deletes link of his answer", :js do
    sign_in(user)
    visit question_path(question)

    within "#answer-#{answer.id}" do
      click_link "Edit"
      click_link "Remove link"
      click_on "Save"
    end

    expect(page).to have_no_link link.name, href: link.url
  end
end
