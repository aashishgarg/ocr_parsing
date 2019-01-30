require 'rails_helper'

RSpec.describe Ocr::ProcessFiles do
  before(:all) do
    @user = FactoryBot.create(:user)
    @bol_file = FactoryBot.create(:bol_file, user: @user)
    @attach = @bol_file.attachments.create(data: File.open("#{Rails.root}/spec/support/attachments/bol_files/448118"))
    @file_processor = Ocr::ProcessFiles.new(@attach, @user)
    @file_processor.send_to_ocr
  end

  context '#ocr_parsed_data' do
    it 'is saved same as returned response' do
      expect(@attach.ocr_parsed_data).to eq(@file_processor.json_response)
    end
  end

  context '#processed_data' do
    it "all keys other than [Details] have a hash with keys ['Value', 'Status']" do
      processed = @attach.processed_data.dup
      processed.delete('Details')
      processed.each do |key, value|
        expect([value.key?('Status'), value.key?('Value')]).to eq([true, true])
      end
    end

    it "all keys in hashes in [Details] have a hash with keys ['Value', 'Status']" do
      processed = @attach.processed_data.dup
      details = processed.delete('Details')
      details.each do |hash|
        hash.each do |key, hash1|
          expect([hash1.key?('Status'), hash1.key?('Value')]).to eq([true, true])
        end
      end
    end

    it 'is not same as returned response' do
      expect(@attach.processed_data).not_to eq(@file_processor.json_response)
    end

    context 'contains required key' do
      Attachment::MERGING_HASH.keys.each do |key|
        it "[#{key}]" do
          expect(@attach.processed_data.key?(key.to_s)).to eq(true)
        end
      end

      context '[Details] further contains required key' do
        Attachment::MERGING_HASH[:Details].each do |hash|
          hash.keys.each do |key|
            it "[#{key}]" do
              expect(@attach.processed_data['Details'].first.key?(key.to_s)).to eq(true)
            end
          end
        end
      end
    end
  end

  it 'all keys of #ocr_parsed_data with a value have same value in #processed_data' do

  end

  after(:all) do
    @bol_file.destroy
  end
end
