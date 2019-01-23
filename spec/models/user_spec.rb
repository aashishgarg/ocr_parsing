require 'rails_helper'

RSpec.describe User, type: :model do
  context '#validations' do
    %w[email first_name last_name].each do |field|
      it "does not allow blank [#{field}]" do
        user = FactoryBot.build(:user, field.to_sym => '')
        expect(user.valid?).to eq(false)
      end
    end

    it 'does not allow duplicate [email]' do
      user = FactoryBot.build(:user, email: FactoryBot.create(:user).email)
      expect(user.valid?).to eq(false)
    end
  end

  context '#role' do
    it 'creates default role = customer' do
      user = FactoryBot.create(:user)
      expect(user.is_customer?).to eq(true)
    end
  end
end
