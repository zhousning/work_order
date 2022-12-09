class CreateFctWxusers < ActiveRecord::Migration
  def change
    create_table :fct_wxusers do |t|
      t.integer :factory_id
      t.integer :wx_user_id

      t.timestamps null: false
    end
  end
end
