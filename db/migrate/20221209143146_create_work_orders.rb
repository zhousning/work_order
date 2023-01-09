class CreateWorkOrders < ActiveRecord::Migration
  def change
    create_table :work_orders do |t|
      t.string :number,  null: false, default: Setting.systems.default_str
    
      t.string :title,  null: false, default: Setting.systems.default_str
    
      t.date :pdt_date
    
      t.text :content
    
      t.string :address,  null: false, default: Setting.systems.default_str
    
      t.boolean :urgent,  null: false, default: Setting.systems.default_boolean

      t.boolean :reminder,  null: false, default: Setting.systems.default_boolean
    
      t.string :state,  null: false, default: Setting.states.opening
    
      t.datetime :order_time
    
      t.datetime :limit_time
    
      t.string :person,  null: false, default: Setting.systems.default_str
    
      t.string :phone,  null: false, default: Setting.systems.default_str
    
      t.text :img
    
      t.references :workorder_ctg
    
      t.references :order_ctg
    
      t.references :factory
    

    
      t.references :user
    
      t.timestamps null: false
    end
  end
end
