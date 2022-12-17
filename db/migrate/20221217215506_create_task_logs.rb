class CreateTaskLogs < ActiveRecord::Migration
  def change
    create_table :task_logs do |t|
    
      t.integer :wx_user_id
    
      t.string :state,  null: false, default: Setting.states.opening
    

    

    

    
      t.references :work_order
    

    
      t.timestamps null: false
    end
  end
end
