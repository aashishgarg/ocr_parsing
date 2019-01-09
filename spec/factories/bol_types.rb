FactoryBot.define do
  factory :bol_type do
    shipper_id { FactoryBot.create(:shipper).id }
    name { FFaker::Name.name }
  end
end
