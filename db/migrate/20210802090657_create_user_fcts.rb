class CreateUserFcts < ActiveRecord::Migration
  def change
    create_table :user_fcts do |t|
      t.integer :user_id
      t.integer :factory_id

      t.timestamps null: false
    end
  end
end
