class Person < ApplicationRecord
    has_many :addresses, dependent: :destroy
    validates :first_name, presence: true
    validates :last_name, presence: true
end
