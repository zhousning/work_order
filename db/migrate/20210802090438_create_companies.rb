class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
    
      t.string :area,  null: false, default: Setting.systems.default_str
    
      t.string :name,  null: false, default: Setting.systems.default_str
    
      t.text :info
    
      t.string :lnt,  null: false, default: Setting.systems.default_str
    
      t.string :lat,  null: false, default: Setting.systems.default_str
    

    
      t.string :logo,  null: false, default: Setting.systems.default_str
    

    

      t.timestamps null: false
    end
  end
end
