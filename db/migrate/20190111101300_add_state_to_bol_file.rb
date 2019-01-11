class AddStateToBolFile < ActiveRecord::Migration[5.2]
  def change
    add_column :bol_files, :state, :string
  end
end
