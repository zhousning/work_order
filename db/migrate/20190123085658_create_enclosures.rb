class CreateEnclosures < ActiveRecord::Migration
  def change
    create_table :enclosures do |t|
      t.timestamps null: false

      t.string :file,  null: false, default: ""

      t.references :notice
      t.references :article
      t.references :task
      t.references :task_report
      t.references :work_order
      t.references :order_log
    end
  end
end
