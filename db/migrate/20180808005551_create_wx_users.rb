class CreateWxUsers < ActiveRecord::Migration
  def change
    create_table :wx_users do |t|
      t.string :unionid, null: false, default: "" 
      t.string :openid, null: false, default: ""
      t.string :name, null: false, default: "" 
      t.string :phone, null: false, default: "" 
      t.string :nickname, null: false, default: "" 
      t.string :avatarurl, null: false, default: ""
      t.string :gender, null: false, default: ""
      t.string :city, null: false, default: ""
      t.string :province, null: false, default: ""
      t.string :country, null: false, default: ""
      t.string :language, null: false, default: ""
      t.string :number, null: false, default: ""

      t.string :state, null: false, default: Setting.states.ongoing 
      t.string :task_state, null: false, default: Setting.states.pending

      t.timestamps null: false
    end
  end
end
