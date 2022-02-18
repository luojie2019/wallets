class PaymentsController < ApplicationController
  
  skip_before_action :required_login, only: [:notification, :notification_js]

  # 订单支付链接
  #
  # @param [string] trade_no 订单号
  # @return [html] 404/transaction.url
  def pay_trade
    recharge_trade = RechargeTrade.find_by(params.permit(:trade_no))
    return render_403 unless recharge_trade
    payment = Payment.find_by(id: recharge_trade.payment_id)
    return render_403 unless payment
    settings = PaymentSetting.official_gateway_setting(payment.pay_type)
    options = PaymentSetting.official_gateway_options(payment.pay_type, recharge_trade, '192.168.0.2')
    transaction = ShopGateway.transaction(payment.pay_type, options)
    redirect_to transaction.url
  end


  # wallets支付链接
  #
  # @param [string] trade_no 订单号
  # @return [html] 404/transaction.url
  def pay_trade_by_wallets
    transfer_trade = TransferTrade.find_by(params.permit(:trade_no))
    return render_403 unless transfer_trade
    return render_403 unless transfer_trade.status == TransferTrade::Status::INIT
    payment = Payment.find_by(id: transfer_trade.payment_id)
    return render_403 unless payment
    if @current_user.recharge_finance > 0 && @current_user.recharge_finance >= transfer_trade.total_amount
      UserRechargeBalance.transaction do
        UserRechargeBalance.add_expenditure(transfer_trade.pay_userid, transfer_trade.total_amount, '钱包转账')
        UserRechargeBalance.add_income(transfer_trade.recv_userid, transfer_trade.total_amount, '钱包转账')
        transfer_trade.update(status: TransferTrade::Status::SUCCESS)
      end
      # web_hook_notify
      return pay_success # "
    else
      return render_403 # "title: 购买失败 msg: 账户余额不足"
    end
  end

  # 支付完成-异步通知
  #
  # @param [string] https://opendocs.alipay.com/open/62/104743
  # @return [html] 404/transaction.url
  def notification_js
    result = Payment.notification(params)
    # return ShopGateway.success_response(gateway_type, '/service/success_url') if result[:code] == 0
    # ''
    return  Payment::NotifyCode[result[:code]]
  end 

  def notification
    excute_block = lambda do |response|
      result = Payment.notification(params)
      response[:rs] = Payment::NotifyCode[result[:code]]
    end
    build_json_response(excute_block) 
  end

end
