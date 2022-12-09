class AddInfoToWorker < ActiveRecord::Migration
  def change
    add_column :workers, :info, :text
  end
end
