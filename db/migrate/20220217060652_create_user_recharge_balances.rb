class CreateUserRechargeBalances < ActiveRecord::Migration[5.2]
  def change
    create_table :user_recharge_balances, comment: "用户收支记录" do |t|
    	t.integer :userid, default: 0, comment: "用户ID"
    	t.string :type_desc, default: '', comment: "类型"
    	t.decimal :income, precision: 10, scale: 2, default: "0.0", comment: "收入金额"
      t.string :remark, default: '', comment: "备注"
      t.string :serial_no, default: '', comment: "流水号"
    	
    	t.boolean :is_deleted, default: false
    	t.timestamps
    end
  end
end
   