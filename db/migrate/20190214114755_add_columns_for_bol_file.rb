class AddColumnsForBolFile < ActiveRecord::Migration[5.2]
  def change
    add_column :bol_files, :qa_approved_at, :datetime
    add_column :bol_files, :released_at, :datetime
  end
end
