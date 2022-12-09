class CreateDeploys < ActiveRecord::Migration
  def change
    create_table :deploys do |t|
    
      t.string :name,  null: false, default: Setting.systems.default_str
    
      t.datetime :start_time
    
      t.datetime :end_time
    
      t.float :expire,  null: false, default: Setting.systems.default_num 
    
      t.string :appid,  null: false, default: Setting.systems.default_str
    
      t.string :secret,  null: false, default: Setting.systems.default_str
    
      t.string :key,  null: false, default: Setting.systems.default_str
    
      t.string :val1,  null: false, default: Setting.systems.default_str
    
      t.string :val2,  null: false, default: Setting.systems.default_str
    
      t.string :val3,  null: false, default: Setting.systems.default_str
    

    

    

    

    
      t.timestamps null: false
    end
  end
end
