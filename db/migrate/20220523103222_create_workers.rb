class CreateWorkers < ActiveRecord::Migration
  def change
    create_table :workers do |t|
    
      t.string :name,  null: false, default: Setting.systems.default_str
    
      t.string :idno,  null: false, default: Setting.systems.default_str
    
      t.string :phone,  null: false, default: Setting.systems.default_str
    
      t.string :gender,  null: false, default: Setting.systems.default_str
    
      t.string :state,  null: false, default: Setting.states.ongoing
    
      t.string :adress,  null: false, default: Setting.systems.default_str
    
      t.string :desc,  null: false, default: Setting.systems.default_str
      t.string :number,  null: false, default: Setting.systems.default_str
    

    
      t.string :avatar,  null: false, default: Setting.systems.default_str
    
      t.string :idfront,  null: false, default: Setting.workers.worker
    
      t.string :idback,  null: false, default: Setting.systems.default_str
    

      t.text :avatar_base
    

      t.text :img
    
      t.integer :wx_inviter

      t.integer :factory


    
      t.timestamps null: false
    end
  end
end
