class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
    
      t.string :name,  null: false, default: Setting.systems.default_str
    
      t.string :tag,  null: false, default: Setting.systems.default_str
      t.boolean :required
    

    

    

    
      t.references :nest
    

      t.timestamps null: false
    end
  end
end
