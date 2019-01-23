require 'rails_helper'

RSpec.describe BolFile, type: :model do
  before do
    @user = FactoryBot.create(:user)
  end
  context 'validations:' do
    it 'with no name' do
      bol_file = FactoryBot.create(:bol_file, user: @user)
      expect(bol_file.valid?).to eq(true)
    end

    it 'with name' do
      bol_file = FactoryBot.create(:bol_file, user: @user, name: nil)
      expect(bol_file.valid?).to eq(true)
    end
  end
end
