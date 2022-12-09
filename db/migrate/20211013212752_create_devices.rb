class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
    
      t.string :idno,  null: false, default: Setting.systems.default_str
    
      t.string :name,  null: false, default: Setting.systems.default_str
    
      t.string :mdno,  null: false, default: Setting.systems.default_str
    
      t.string :unit,  null: false, default: Setting.systems.default_str
    
      t.date :out_date
    
      t.date :mount_date
    
      t.string :supplier,  null: false, default: Setting.systems.default_str
    
      t.string :mfcture,  null: false, default: Setting.systems.default_str
    
      t.string :pos,  null: false, default: Setting.systems.default_str
    
      t.string :pos_no,  null: false, default: Setting.systems.default_str
    
      t.float :life,  null: false, default: Setting.systems.default_num 
    
      t.string :qrcode_uid
    
      t.string :state,  null: false, default: Setting.systems.default_str
    
      t.text :desc
    

    
      t.string :avatar,  null: false, default: Setting.systems.default_str
    

    

    
      t.references :factory
    

    
      t.timestamps null: false
    end
  end
end
