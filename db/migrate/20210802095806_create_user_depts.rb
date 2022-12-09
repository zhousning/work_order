class CreateUserDepts < ActiveRecord::Migration
  def change
    create_table :user_depts do |t|
      t.integer :user_id
      t.integer :department_id

      t.timestamps null: false
    end
  end
end
