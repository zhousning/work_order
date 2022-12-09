class CreateRolePermissionships < ActiveRecord::Migration
  def change
    create_table :role_permissionships do |t|
      t.integer :role_id
      t.integer :permission_id

      t.timestamps null: false
    end
  end
end
