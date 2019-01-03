class CreateAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :attachments do |t|
      t.belongs_to :attachable, polymorphic: true
      t.attachment :data

      t.timestamps
    end

    add_index :attachments, [:attachable_id, :attachable_type]
  end
end
