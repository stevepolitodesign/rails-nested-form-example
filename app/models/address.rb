class Address < ApplicationRecord
  belongs_to :person
  validates :kind, presence: true
  validates :street, presence: true
end
