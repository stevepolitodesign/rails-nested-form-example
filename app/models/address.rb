class Address < ApplicationRecord
  belongs_to :person, optional: true
  validates :kind, presence: true
  validates :street, presence: true
end
