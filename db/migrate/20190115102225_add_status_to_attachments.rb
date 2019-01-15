class AddStatusToAttachments < ActiveRecord::Migration[5.2]
  def change
    add_column :attachments, :status, :integer
    remove_column :bol_files, :state, :string
  end
end
