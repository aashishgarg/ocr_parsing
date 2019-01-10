class ChangeOcrParsedDataModel < ActiveRecord::Migration[5.2]
  def change
    remove_column :bol_files, :ocr_parsed_data, :jsonb
    add_column :attachments, :ocr_parsed_data, :jsonb
  end
end
