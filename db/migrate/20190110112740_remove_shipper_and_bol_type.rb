class RemoveShipperAndBolType < ActiveRecord::Migration[5.2]
  def change
    drop_table :shippers
    drop_table :bol_types
  end
end
