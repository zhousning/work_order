class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :name,                null: false, default: ""
      t.string :subject_class,       null: false, default: ""
      t.string :action,              null: false, default: ""
      t.integer :subject_id,         null: false, default: 0
      t.text :description

      t.timestamps null: false
    end
  end
end
