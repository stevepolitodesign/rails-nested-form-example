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
    it "can have many addresses" do
      skip
    end
    it "destroys associated addresses when destroyed" do
      skip
    end    
  end
end
