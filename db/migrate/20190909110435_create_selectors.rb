class CreateSelectors < ActiveRecord::Migration
  def change
    create_table :selectors do |t|
    
      t.string :name,  null: false, default: Setting.systems.default_str
    
      t.boolean :file,  null: false, default: Setting.systems.default_boolean
    
      t.string :title,  null: false, default: Setting.systems.default_str
      t.string :category,  null: false, default: Setting.systems.default_str

      t.references :spider
    

    

      t.timestamps null: false
    end
  end
end
