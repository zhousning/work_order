class CreateOrderLogs < ActiveRecord::Migration
  def change
    create_table :order_logs do |t|
      t.integer :worker_order_id
      t.integer :wx_user_id
    
      t.boolean :feedback,  null: false, default: Setting.systems.default_boolean
    
      t.text :content
    
      t.string :longitude,  null: false, default: Setting.systems.default_str
    
      t.string :latitude,  null: false, default: Setting.systems.default_str
    
      t.integer :upman,  null: false, default: Setting.systems.default_num 
    
      t.integer :nextman,  null: false, default: Setting.systems.default_num 
    
      t.datetime :start_time
    
      t.datetime :end_time
    
      t.string :state,  null: false, default: Setting.systems.default_str
    
      t.text :img
    
      t.text :address
    
      t.string :item,  null: false, default: Setting.systems.default_str
    

    

    

    

    
      t.references :user
    
      t.timestamps null: false
    end
  end
end
