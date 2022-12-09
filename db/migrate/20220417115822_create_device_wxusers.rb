class CreateDeviceWxusers < ActiveRecord::Migration
  def change
    create_table :device_wxusers do |t|
      t.integer :device_id
      t.integer :wx_user_id

      t.timestamps null: false
    end
  end
end
