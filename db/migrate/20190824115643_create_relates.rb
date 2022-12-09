class CreateRelates < ActiveRecord::Migration
  def change
    create_table :relates do |t|
      t.string :relate_type
      t.string :obj

      t.references :template

      t.timestamps null: false
    end
  end
end
