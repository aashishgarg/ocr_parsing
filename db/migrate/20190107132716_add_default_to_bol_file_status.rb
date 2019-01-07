class AddDefaultToBolFileStatus < ActiveRecord::Migration[5.2]
  def change
    change_column_default :bol_files, :status, from: nil, to: 0
  end
end
