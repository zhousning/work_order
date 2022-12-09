class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string    :number
      t.string    :category, null: false, default: "none"
      t.float   :money          # 业务，同时也是支付金额
      t.float   :coin           # 业务，金额相应的币值
      t.integer   :status, null: false, default: 0  # no use

      t.string    :subject        # 发送，支付标题
      t.string    :trade_no       # 返回，交易号
      t.string    :total_fee      # 返回，实际支付金额
      t.string    :buyer_email    # 返回，用户支付宝
      t.datetime  :gmt_create     # 返回，创建时间
      t.datetime  :gmt_payment    # 返回，支付时间
      t.text      :notify_msg     # 返回，返回信息
      t.integer   :price          # no use
      t.integer   :quantity       # no use
      t.string    :state, null: false, default: "opening"

      t.references :user

      t.timestamps null: false
    end
  end
end
