FactoryBot.define do
  factory :shipper do
    name { FFaker::Name.name }
    address1 { FFaker::AddressUS.street_name }
    address2 { FFaker::AddressUS.street_address }
    city { FFaker::AddressUS.city }
    state { FFaker::AddressUS.state }
    zip { FFaker::AddressUS.zip_code }
    contact_name { FFaker::Name.name }
    contact_email { FFaker::Internet.email }
    contact_phone { FFaker::PhoneNumber.phone_number }
    contact_fax { FFaker::PhoneNumber.phone_number }
  end
end
