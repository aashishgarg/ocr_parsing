class UpdateColumnInBolFile < ActiveRecord::Migration[5.2]
  def change
    add_column :bol_files, :extracted_at, :datetime
    remove_column :bol_files, :status_updated_at, :integer
    remove_column :bol_files, :shipper_id, :integer
  end
end
