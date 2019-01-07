class AddContactDetailsTo < ActiveRecord::Migration[5.2]
  def change
    add_column :shippers, :contact_name, :string
    add_column :shippers, :contact_email, :string
    add_column :shippers, :contact_phone, :string
    add_column :shippers, :contact_fax, :string
  end
end
