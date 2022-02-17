class PaymentSetting < ApplicationRecord

	GatewaySetting = {
		:alipay => {:partner => ENV['ALIPAY_PRRTNER'], :seller_email => ENV['ALIPAY_SELLER_EMAIL'], :key => ENV['ALIPAY_KEY']}
	}

  # 支付网关配置
  #
  # @param [string] pay_type 支付方式
  # @return [Hash] settings 默认配置
  def self.official_gateway_setting(pay_type)
    PaymentSetting::GatewaySetting[pay_type.to_sym]
  end

  # 支付网关参数
  #
  # @param [string] pay_type 支付方式
  # @param [record] trade 订单
  # @return [Hash] options 网关参数
  def self.official_gateway_options(pay_type, trade, client_ip)
    settings = PaymentSetting.official_gateway_setting(pay_type)
    {
      :partner => settings[:partner],
      :seller_email => settings[:seller_email],
      :key => settings[:key],
      :out_trade_no => trade.trade_no,
      :total_fee => trade.total_amount.to_s,
      :subject => 'Wallets充值-订单支付',
      :body => '支付金额' + trade.total_amount.to_s,
      :notify_url => "http://yhsd_doma.com/payment/callback/#{pay_type}/#{pay_type}/notify",
      :return_url => "https://www.baidu.com/",
      :extra_common_param => 'extra_common_param',
      :created_at => trade.created_at.strftime('%Y%m%d%H%M%S'),
      :expired_at => (trade.created_at + 86400).strftime('%Y%m%d%H%M%S'),
      :client_ip => client_ip,
      :is_bank => false
    }
  end
  # https://www.baidu.com/?body=%E6%94%AF%E4%BB%98%E9%87%91%E9%A2%9D0.01&buyer_email=185****0248&buyer_id=2088012892381668&exterface=create_direct_pay_by_user&extra_common_param=extra_common_param&is_success=T&notify_id=RqPnCoPT3K9%252Fvwbh3ItYxLVtOL2bs%252FKlZYqHLBGXQrmgcQ0NMMo4bHdP37IiSbNoZAP3&notify_time=2022-02-17+09%3A36%3A46&notify_type=trade_status_sync&out_trade_no=94D3E80B531B4585B1F18EE7B6E5525D&payment_type=1&seller_email=yee***%40yeezon.com&seller_id=2088801482754883&subject=Wallets%E5%85%85%E5%80%BC-%E8%AE%A2%E5%8D%95%E6%94%AF%E4%BB%98&total_fee=0.01&trade_no=2022021722001481661429724789&trade_status=TRADE_SUCCESS&sign=d22a6326bc3e2b383531d68d3f79e6d8&sign_type=MD5

end	
 