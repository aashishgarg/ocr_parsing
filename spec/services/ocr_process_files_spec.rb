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
      expect(@attach.ocr_parsed_data).to eq(@file_processor.response_body)
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

    it '[Details] hash all required keys' do
      expect(@attach.processed_data['Details'].first.keys).to eq(Attachment::MERGING_HASH[:Details].first.keys.map(&:to_s))
    end

    it '[Details] is blank array if no related key is available in ocr_response' do
      %w[hazmat pieces weight description].each { |key| @file_processor.response_body['data'].delete(key) }
      response = @file_processor.process_ocr_data
      expect(response['Details']).to eq([])
    end

    it 'is not same as returned response' do
      expect(@attach.processed_data).not_to eq(@file_processor.response_body)
    end

    it 'contains same keys of ocr_parsed_data' do
      ocr_hash = Ocr::CustomRules.new(@attach.ocr_parsed_data['data']).apply_all
      ocr_keys = ocr_hash.keys.collect(&:apply_transform_rule!).sort
      processed_hash = @attach.processed_data.dup
      details_keys = processed_hash.delete('Details').first&.keys || []
      processed_keys = (processed_hash.keys + details_keys).flatten.sort
      expect(ocr_keys - processed_keys).to eq([])
    end
  end

  after(:all) do
    @bol_file.destroy
  end
end
