class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
    
      t.string :title,  null: false, default: Setting.systems.default_str
    
      t.string :html_link,  null: false, default: Setting.systems.default_str
    
      t.integer :status,  null: false, default: Setting.systems.default_num 
    

    
      t.references :mth_pdt_rpt
    

      t.timestamps null: false
    end
  end
end
