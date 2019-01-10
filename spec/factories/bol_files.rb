FactoryBot.define do
  factory :bol_file do
    shipper_id { FactoryBot.create(:shipper).id }
    bol_type_id { FactoryBot.create(:bol_type).id }
    name { FFaker::Name.name }
    status { 'uploaded' }
    status_updated_by { FactoryBot.create(:user).id }
    status_updated_at { DateTime.now }
    ocr_parsed_data { 'OCR parsed data' }
  end
end
