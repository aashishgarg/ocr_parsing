class AddDetailsToBolFile < ActiveRecord::Migration[5.2]
  def change
    add_column :bol_files, :bol_number, :string
    add_column :bol_files, :pitt_pro, :string
  end
end
