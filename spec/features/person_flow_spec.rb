require 'rails_helper'

RSpec.feature "PersonFlows", type: :feature do
  describe "index page" do
    let!(:person_one) { FactoryBot.create(:person) }
    let!(:person_two) { FactoryBot.create(:person) }
    it "lists all persons" do
      visit people_path
      Person.all.count do |person|
        expect(page).to have_content(person.first_name)
        expect(page).to have_content(person.last_name)
        expect(page).to have_link("See More", href: person_path(person))
      end
    end
  end
  describe "show page" do
    let(:person) { FactoryBot.create(:person) }
    it "displays person's first and last name" do
      visit person_path(person)
      expect(page).to have_content(person.first_name)
      expect(page).to have_content(person.last_name)
    end
  end
  describe "edit page" do
    let(:person) { FactoryBot.create(:person) }
    first_name = "Steve"
    last_name = "Polito"
    it "diplays a form to edit the person" do
      visit edit_person_path(person)
      fill_in("First name", with: first_name)
      fill_in("Last name", with: last_name)
      click_button("Update Person")
      expect(page).to have_content("#{first_name} #{last_name} was successfully updated.")
      expect(page).to have_current_path(person_path(person))
    end
    it "displays a link to delete the person" do
      visit edit_person_path(person)
      click_link("Delete Person")
      expect(page).to have_current_path(people_path)
      expect(page).to have_content("#{person.first_name} #{person.last_name} was successfully deleted.")
    end
  end
  describe "new page" do
    first_name = "Steve"
    last_name = "Polito"
    it "displays a form to create a new person" do
      visit new_person_path
      fill_in("First name", with: first_name)
      fill_in("Last name", with: last_name)
      click_button("Create Person")
      expect(page).to have_content("#{first_name} #{last_name} was successfully created.")
      expect(page).to have_current_path(person_path(Person.last))
    end
  end
  describe "form errors" do
    it "displays errors if the form is not valid" do
      visit new_person_path
      fill_in("First name", with: "")
      fill_in("Last name", with: "")
      click_button("Create Person")
      expect(page).to have_content("prohibited this form from saving.")
    end
  end
end
