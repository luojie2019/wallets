class Payment < ApplicationRecord
  
  scope :not_deleted, -> { where(is_deleted: false) }

  PayType = {
    :"#{0}"=> '支付宝',
    :"#{1}"=> '支付宝（二维码）',
    :"#{2}"=> '支付宝（网银直联）',
    :"#{3}"=> '微信'
   }

  GatewayType = {
    :"#{0}"=> 'alipay',
    :"#{1}"=> 'alipay_qrcode',
    :"#{2}"=> 'alipay_bank',
    :"#{4}"=> 'wppay'
  }

  # 支付回调状态码
  module NotifyCode
    extend self
    TRADE_CLOSED = 0
    WAIT_BUYER_PAY = 1
    TRADE_SUCCESS = 2
  
    def [](name)
      {
        :"#{0}" => '交易关闭',
        :"#{1}" => '交易创建',
        :"#{2}" => '支付成功'
      }[name.to_s.to_sym]
    end
  end

  # 校验支付方式合法性
  #
  # @param [string] pay_type 支付方式
  # @return [boolean] true/false
  def self.validate_pay_type(pay_type)
    Payment::GatewayType.values.include?(pay_type)
  end

  # 处理支付完成异步通知
  #
  # @param [string] pay_type 支付方式
  # @return [boolean] true/false
  def self.notification(params)
    rs = {code: Payment::NotifyCode::WAIT_BUYER_PAY, trade_no: params[:out_trade_no]}
    settings = PaymentSetting.official_gateway_setting(params[:gateway_type])
    notification = ShopGateway.notification(params[:gateway_type], settings, params)
    return rs unless notification.complete
    # return rs unless notification.acknowledge
    return rs if notification.status == 'WAIT_BUYER_PAY'
    if notification.status == 'TRADE_CLOSE'
      rs[:code] = Payment::NotifyCode::TRADE_SUCCESS
      return rs  
    end
    payment = Payment.find_by(trade_no: notification.out_trade_no, pay_type: params[:gateway_type])
    if payment.success == true
      rs[:code] = Payment::NotifyCode::TRADE_CLOSED
      return rs
    end
    # 推送到处理成功队列
    RechargeSuccessTrade.recharge_trade(payment, params[:gateway_trade_no])
    rs
  end

end
