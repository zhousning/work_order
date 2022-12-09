class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
    
      t.string :name,  null: false, default: Setting.systems.default_str
    
      t.text :info
    

    

    

    
      t.references :factory
    
      t.timestamps null: false
    end
  end
end
