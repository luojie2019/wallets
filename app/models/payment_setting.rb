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
      :notify_url => "#{ENV['PAY_HOST']}payment/notification/#{pay_type}/#{trade.trade_no}",
      :return_url => "#{ENV['PAY_HOST']}payment/notification/#{pay_type}/#{trade.trade_no}",
      :extra_common_param => 'extra_common_param',
      :created_at => trade.created_at.strftime('%Y%m%d%H%M%S'),
      :expired_at => (trade.created_at + 86400).strftime('%Y%m%d%H%M%S'),
      :client_ip => client_ip,
      :is_bank => false
    }
  end

end	
