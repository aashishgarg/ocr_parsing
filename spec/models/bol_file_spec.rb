require 'rails_helper'

RSpec.describe BolFile, type: :model do
  before do
    @user = FactoryBot.create(:user)
  end
  context '#validations' do
    it 'does not allow blank [status]' do
      bol_file = FactoryBot.build(:bol_file, user: @user, name: nil, status: nil)
      expect(bol_file.valid?).to eq(false)
    end

    it 'with no name' do
      bol_file = FactoryBot.create(:bol_file, user: @user)
      expect(bol_file.valid?).to eq(true)
    end

    it 'with name' do
      bol_file = FactoryBot.create(:bol_file, user: @user, name: nil)
      expect(bol_file.valid?).to eq(true)
    end
  end

  context '#Callback' do
    context 'when status = qa_approved' do
      before do
        @bol_file = FactoryBot.create(:bol_file, user: @user, name: nil)
        @bol_file.update(status: 'qa_approved')
      end
      it 'sets qa_approved_at = DateTime' do
        expect(@bol_file.qa_approved_at?).to eq(true)
      end

      it 'sets released_at = nil' do
        expect(@bol_file.released_at?).to eq(false)
      end
    end

    context 'when status = released' do
      before do
        @bol_file = FactoryBot.create(:bol_file, user: @user, name: nil)
        @bol_file.update(status: 'qa_approved')
        @bol_file.update(status: 'released')
      end
      it 'sets qa_approved_at = DateTime' do
        expect(@bol_file.qa_approved_at?).to eq(true)
      end

      it 'sets released_at = DateTime' do
        expect(@bol_file.released_at?).to eq(true)
      end
    end

    context 'when status < qa_approved' do
      before do
        @bol_file = FactoryBot.create(:bol_file, user: @user, name: nil)
        @bol_file.update(status: 'ocr_pending')
      end
      it 'sets qa_approved_at = nil' do
        expect(@bol_file.qa_approved_at?).to eq(false)
      end

      it 'sets released_at = nil' do
        expect(@bol_file.released_at?).to eq(false)
      end
    end

    context 'when status.between?(qa_approved and released)' do
      before do
        @bol_file = FactoryBot.create(:bol_file, user: @user, name: nil)
        @bol_file.update(status: 'qa_approved')
        @bol_file.update(status: 'uat_rejected')
      end
      it 'sets qa_approved_at = DateTime' do
        expect(@bol_file.qa_approved_at?).to eq(true)
      end

      it 'sets released_at = DateTime' do
        expect(@bol_file.released_at?).to eq(false)
      end
    end
  end
end
