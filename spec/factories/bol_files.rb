FactoryBot.define do
  factory :bol_file do
    bol_type_id { 1 }
    name { FFaker::Name.name }
    status { 0 }
  end
end
