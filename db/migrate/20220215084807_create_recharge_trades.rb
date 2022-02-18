class CreateRechargeTrades < ActiveRecord::Migration[5.2]
  def change
    create_table :recharge_trades, comment: "充值订单" do |t|
      t.integer :userid, default: 0, comment: "用户ID"
      t.string :trade_no, default: '', comment: "订单号"
      t.decimal :total_amount, precision: 10, scale: 2, default: "0.0", comment: "订单金额"
      t.integer :status, default: 0, comment: "状态:0init 1expired 2success 3cancel 4deal"
      t.integer :payment_id, default: 0, comment: "支付方ID"
      t.string :remark, default: '', comment: "备注"
      
      t.boolean :is_deleted, default: false
      t.timestamps
    end
  end
end

 