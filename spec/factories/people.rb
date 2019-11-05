FactoryBot.define do
  factory :person do
    sequence(:first_name) { |n| "First Name #{n}"}
    sequence(:last_name) { |n| "Last Name #{n}"}

    factory :person_with_addresses do
      transient do
        addresses_count { 5 }
      end

      after(:create) do |person, evaluator|
        create_list(:address, evaluator.addresses_count, person: person)
      end
    end

  end
end
