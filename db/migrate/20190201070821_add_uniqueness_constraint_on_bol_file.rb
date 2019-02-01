class AddUniquenessConstraintOnBolFile < ActiveRecord::Migration[5.2]
  def change
    add_index :bol_files, :name, unique: true
  end
end
