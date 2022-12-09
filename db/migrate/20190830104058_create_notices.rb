class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
    
      t.string :title,  null: false, default: Setting.systems.default_str
    
      t.text :content
    

    

      t.timestamps null: false
    end
  end
end
