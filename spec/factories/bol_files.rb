FactoryBot.define do
  factory :bol_file do
    shipper_id 1
    bol_type_id 1
    name { FFaker::Name.name }
    status { 'uploaded' }
    status_updated_by { FactoryBot.create(:user).id }
    status_updated_at { DateTime.now }
  end
end
