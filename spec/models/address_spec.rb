require 'rails_helper'

RSpec.describe Address, type: :model do
  describe "creation" do
    let!(:address) { FactoryBot.create(:address) }
    it "can be created" do
      expect(address).to be_valid
    end
  end
  describe "validations" do
    let(:address) { FactoryBot.build(:address) }
    it "should have a kind" do
      address.kind = nil
      expect(address).to_not be_valid
    end
    it "should have a street" do
      address.street = nil
      expect(address).to_not be_valid
    end
  end
end