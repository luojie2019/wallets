class CreateRechargeSuccessTrades < ActiveRecord::Migration[5.2]
  def change
    create_table :recharge_success_trades, comment: "充值成功订单" do |t|
    	t.integer :userid, default: 0, comment: "用户ID"
    	t.string :trade_no, default: '', comment: "订单号"
    	t.decimal :total_amount, precision: 10, scale: 2, default: "0.0", comment: "订单金额"
      t.string :remark, default: '', comment: "备注"
    	
    	t.boolean :is_deleted, default: false
    	t.timestamps
    end
  end
end
