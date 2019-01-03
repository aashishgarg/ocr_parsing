class CreateBolTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :bol_types do |t|
      t.integer :shipper_id
      t.string :name

      t.timestamps
    end
  end
end
