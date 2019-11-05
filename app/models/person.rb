class Person < ApplicationRecord
    has_many :addresses, dependent: :destroy
    accepts_nested_attributes_for :addresses, allow_destroy: true, reject_if: :all_blank
    validates :first_name, presence: true
    validates :last_name, presence: true
end
