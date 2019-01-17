class AddSerialNoToAttachment < ActiveRecord::Migration[5.2]
  def change
    add_column :attachments, :serial_no, :integer
  end
end
