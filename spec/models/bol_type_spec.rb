require 'rails_helper'

RSpec.describe BolType, type: :model do
  context 'validations:' do
    it 'with no name' do
      bol_type = FactoryBot.create(:bol_type)
      expect(bol_type.valid?).to eq(true)
    end

    it 'with name' do
      bol_type = FactoryBot.build(:bol_type, name: nil)
      expect(bol_type.valid?).to eq(false)
    end
  end
end
