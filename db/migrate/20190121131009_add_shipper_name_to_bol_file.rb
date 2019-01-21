class AddShipperNameToBolFile < ActiveRecord::Migration[5.2]
  def change
    add_column :bol_files, :shipper_name, :string
  end
end
