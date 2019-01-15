class AddProcessedDataToAttachments < ActiveRecord::Migration[5.2]
  def change
    add_column :attachments, :processed_data, :jsonb
  end
end
