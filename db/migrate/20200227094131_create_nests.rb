class CreateNests < ActiveRecord::Migration
  def change
    create_table :nests do |t|
    
      t.string :name,  null: false, default: Setting.systems.default_str
    

    

    

    
      t.references :template
    

      t.timestamps null: false
    end
  end
end
