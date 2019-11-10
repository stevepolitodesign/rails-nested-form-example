require 'rails_helper'

RSpec.feature "HomePages", type: :feature do
  describe "homepage" do
    let!(:person) { FactoryBot.create(:person) }
    it "loads people index page" do
      visit root_path
      expect(page).to have_content(person.first_name)
    end
  end
end
