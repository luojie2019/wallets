class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users, comment: "用户表" do |t|
      t.string :trade_no, default: '', comment: "订单号"
      t.integer :pay_userid, default: 0, comment: "付款方userid"
      t.integer :recv_userid, default: 0, comment: "收款方userid"  
      t.decimal :total_amount, precision: 10, scale: 2, default: "0.0", comment: "订单金额"
      t.integer :status, default: 0, comment: "状态:0init 1expired 2success 3cancel 4deal"
      t.integer :payment_id, default: 0, comment: "支付ID"
      t.string :remark, default: '', comment: "备注"
    	
    	t.boolean :is_deleted, default: false
    	t.timestamps
    end
  end
end
