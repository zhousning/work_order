class CreateSignLogs < ActiveRecord::Migration
  def change
    create_table :sign_logs do |t|
    
      t.date :sign_date
    
      t.integer :wx_user_id,  null: false, default: Setting.systems.default_num 
    
      t.integer :device_id,  null: false, default: Setting.systems.default_num 
    

    
      t.string :avatar,  null: false, default: Setting.systems.default_str

      t.text :avatar_base
    

      t.string :longitude,  null: false, default: Setting.systems.default_str

      t.string :latitude,  null: false, default: Setting.systems.default_str
    

    
      t.references :worker
    

    
      t.timestamps null: false
    end
  end
end
