FactoryBot.define do
  factory :bol_file do
    shipper_id 1
    bol_type_id 1
    name { FFaker::Name.name }
    status { 'uploaded' }
  end
end
