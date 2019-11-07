require 'rails_helper'

RSpec.feature "NestedForms", type: :feature do
  describe "nested address form", js: true do
    let!(:person) { FactoryBot.create(:person) }
    let!(:person_with_addresses) { FactoryBot.create(:person_with_addresses) }
    it "allows a user to add multiple addresses" do
      visit edit_person_path(person)
      click_link("Add Address")      
      within( find(".nested-fields") ) do
        fill_in("Kind", with: "Home")
        fill_in("Street", with: "123 Home St")                 
      end
      click_link("Add Address")
      within( find(".nested-fields:last-of-type") ) do
        fill_in("Kind", with: "Work")
        fill_in("Street", with: "123 Work St")                 
      end
      click_button("Update Person")
      expect(page).to have_current_path(person_path(person))
      Person.last.addresses.each do |address|
        expect(page).to have_content("Home")
        expect(page).to have_content("123 Home St")
        expect(page).to have_content("Work")
        expect(page).to have_content("123 Work St")        
      end
    end
    it "does not save an empty address" do
      visit edit_person_path(person)
      click_link("Add Address")      
      within( find(".nested-fields") ) do
        fill_in("Kind", with: "")
        fill_in("Street", with: "")                 
      end
      click_button("Update Person")
      expect(page).to have_current_path(person_path(person))
      expect(page).to_not have_content("Addresses:")
    end
    it "allows a user to delete multiple addresses" do
      adddress_kind = person_with_addresses.addresses.first.kind
      adddress_street = person_with_addresses.addresses.first.street

      visit edit_person_path(person_with_addresses)
      expect( find("fieldset .nested-fields:first-of-type").find_field("Kind").value ).to eq(adddress_kind)
      expect( find("fieldset .nested-fields:first-of-type").find_field("Street").value ).to eq(adddress_street)
      find("fieldset .nested-fields:first-of-type").click_link("Remove")
      element = page.find("fieldset .nested-fields:first-of-type", visible: :all)
      expect(element).to match_css("fieldset .nested-fields:first-of-type", visible: :hidden)
      click_button("Update Person")
      expect(page).to have_current_path(person_path(person_with_addresses))
      expect(page).to_not have_content(adddress_kind)
      expect(page).to_not have_content(adddress_street)
    end
  end
end
