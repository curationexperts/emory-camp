require 'rails_helper'

RSpec.feature 'Search for an ETD' do
  let(:title) { ['China and its Minority Population'] }
  let(:creator) { ['Eun, Dongwon'] }
  let(:keyword) { ['China', 'Minority Population'] }
  let(:degree) { ['Bachelor of Arts with Honors'] }
  let(:visibility) { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC }
  let :etd do
    Etd.new(
      title: title,
      creator: creator,
      keyword: keyword,
      visibility: visibility,
      degree: degree
    )
  end

  context 'a logged in user' do
    let(:user_attributes) do
      { email: 'test@example.com' }
    end
    let(:user) do
      User.new(user_attributes) { |u| u.save(validate: false) }
    end

    before do
      login_as user
      etd.save
    end

    scenario "Search for an ETD" do
      visit("/")
      fill_in "q", with: "China"
      click_button "Go"
      # Uncomment this to display the HTML capybara is seeing
      # puts page.body
      expect(page).to have_content etd.title.first
      expect(page).to have_content etd.creator.first
      expect(page).to have_content etd.keyword.first
      expect(page).to have_content etd.degree.first
      # Now look for degree in the facets on the left
      expect(page).to have_xpath("//h3", text: "Creator")
      expect(page).to have_link(etd.creator.first, class: "facet_select")
      expect(page).to have_xpath("//h3", text: "Degree")
      expect(page).to have_link(etd.degree.first, class: "facet_select")
    end
  end
end
