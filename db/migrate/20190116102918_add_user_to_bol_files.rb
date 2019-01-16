class AddUserToBolFiles < ActiveRecord::Migration[5.2]
  def change
    add_reference :bol_files, :user, foreign_key: true
    remove_column :bol_files, :status_updated_by, :integer
  end
end
