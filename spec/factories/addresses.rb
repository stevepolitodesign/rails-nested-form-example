FactoryBot.define do
  factory :address do
    sequence(:kind) { |n| "Home #{n}"}
    sequence(:street) { |n| "#{n} Main St."}
    person
  end
end
