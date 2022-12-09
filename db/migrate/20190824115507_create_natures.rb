class CreateNatures < ActiveRecord::Migration
  def change
    create_table :natures do |t|
      t.string :name
      t.string :data_type
      t.string :title
      t.string :tag
      t.boolean :required

      t.references :template

      t.timestamps null: false
    end
  end
end
