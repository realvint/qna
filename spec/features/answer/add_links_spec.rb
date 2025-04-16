# frozen_string_literal: true

require "rails_helper"

feature "User can add links to answer", "
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:gist_url) { "https://gist.github.com" }
  given(:link_url) { "https://ya.ru" }

  describe "User adds", :js do
    background do
      sign_in(user)

      visit question_path(question)

      fill_in "Body", with: "My answer"
    end

    scenario "link when give an answer" do
      fill_in "Link name", with: "My gist"
      fill_in "Url", with: gist_url

      click_on "Answer"

      within ".answers" do
        expect(page).to have_link "My gist", href: gist_url
      end
    end

    scenario "a few links when give an answer" do
      fill_in "Link name", with: "My gist"
      fill_in "Url", with: gist_url

      click_link "Add one more link"

      within all(".nested-fields").last do
        fill_in "Link name", with: "My link"
        fill_in "Url", with: link_url
      end

      click_button "Answer"

      within ".answers" do
        expect(page).to have_link "My gist", href: gist_url
        expect(page).to have_link "My link", href: link_url
      end
    end
  end
end
