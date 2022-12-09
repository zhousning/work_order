class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.timestamps null: false

      t.string :file,  null: false, default: ""
      t.references :work_order
      t.references :order_log
    end
  end
end
