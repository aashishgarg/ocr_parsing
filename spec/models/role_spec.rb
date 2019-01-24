require 'rails_helper'

RSpec.describe BolFile, type: :model do
  context '#validations' do
    it 'with name' do
      role = FactoryBot.create(:role)
      expect(role.valid?).to eq(true)
    end
  end
end
