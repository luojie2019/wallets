class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments, comment: "支付表" do |t|
    	t.boolean :success, default: false, comment: "支付成功"
        t.boolean :dealing, default: true, comment: "处理中"
    	t.string :pay_type, default: '', comment: "支付方式:alipay|alipay_qrcode"
    	t.string :trade_no, default: '', comment: "订单号"
    	t.string :gateway_trade_no, default: '', comment: "订单号"
    	
    	t.boolean :is_deleted, default: false
    	t.timestamps
    end
  end
end

