FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    company { FFaker::Company.name }
    phone { FFaker::PhoneNumber.phone_number }
    fax { FFaker::PhoneNumber.phone_number }
    password { 'Welcome@123' }
  end
end
