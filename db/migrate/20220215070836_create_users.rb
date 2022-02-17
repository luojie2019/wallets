class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users, comment: "用户表" do |t|
    	t.integer :userid, default: 0, comment: "用户ID"
    	t.string :name, default: '', comment: "昵称"
    	t.string :mobile, default: '', comment: "手机"
    	t.string :email, default: '', comment: "邮箱"
    	t.string :avatar, default: "", comment: "头像"
    	t.string :token, default: '', comment: "登录认证"
        t.decimal :recharge_finance, precision: 10, scale: 2, default: "0.0", comment: "充值资金"
    	
    	t.boolean :is_deleted, default: false
    	t.timestamps
    end
  end
end
