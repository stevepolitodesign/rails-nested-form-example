require 'rails_helper'

RSpec.describe Person, type: :model do
  describe "creation" do
    let(:person) { FactoryBot.create(:person) }
    it "can be created" do
      expect(person).to be_valid
    end
  end
  describe "validations" do
    let(:person) { FactoryBot.build(:person) }
    it "must have a first name" do
      person.first_name = nil
      expect(person).to_not be_valid
    end
    it "must have a first last" do
      person.last_name = nil
      expect(person).to_not be_valid
    end    
  end
  describe "associated addresses" do
    let!(:person_with_addresses) { FactoryBot.build(:person_with_addresses) }
    it "can have many addresses" do
      expect(described_class.reflect_on_association(:addresses).macro).to eq(:has_many)
    end
    it "destroys associated addresses when destroyed" do
      address_count = person_with_addresses.addresses.count
      expect { person_with_addresses.destroy }.to change { Address.count }.by(-address_count)
    end    
  end
end
