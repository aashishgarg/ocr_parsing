class CreateBolFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :bol_files do |t|
      t.integer :shipper_id
      t.integer :bol_type_id
      t.string :name
      t.integer :status
      t.integer :status_updated_by
      t.datetime :status_updated_at
      t.jsonb :ocr_parsed_data

      t.timestamps
    end

    add_index :bol_files, :shipper_id
    add_index :bol_files, :bol_type_id
    add_index :bol_files, :status_updated_by
  end
end
