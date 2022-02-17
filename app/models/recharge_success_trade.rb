class RechargeSuccessTrade < ApplicationRecord

	scope :not_deleted, -> { where(is_deleted: false) }

  validates_numericality_of :total_amount, greater_than: 0
  
	# 充值成功订单
  #
  # @param [Object] payment 支付信息
  # @param [string] gateway_trade_no 网关订单号
  # @return [string] trade_no 订单号
  def self.recharge_trade(payment, gateway_trade_no)
    return unless recharge_trade = RechargeTrade.find_by(trade_no: payment.trade_no, payment_id: payment.id)
    return unless user = User.find_by(userid: recharge_trade.userid)
    # 添加充值记录
    RechargeSuccessTrade.create(recharge_trade.slice(:userid, :total_amount, :remark, :trade_no))
    # 添加收支记录
    UserRechargeBalance.add_income(user.userid, recharge_trade.total_amount, 'Wallets充值记录')
    # 支付信息更新
    payment.update(:gateway_trade_no => gateway_trade_no, :success => true, :dealing => false)
    # 同步通知
    # do something
  end
	
end	
 