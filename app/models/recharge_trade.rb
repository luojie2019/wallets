class RechargeTrade < ApplicationRecord

	scope :not_deleted, -> { where(is_deleted: false) }

  validates_numericality_of :total_amount, greater_than: 0

  before_create do |item|
    # generate_unique_no => 后期可用一些算法生成
    item.trade_no = SecureRandom.uuid.delete('-').upcase
  end
  
	# 充值订单创建
  #
  # @param [integer] userid 用户ID
  # @param [decimal] amount 充值金额
  # @param [string] pay_type 支付方式
  # @param [string] remark 备注
  # @return [string] trade_no 订单号
  def self.build_recharge_trade(userid, amount, pay_type, remark)
    # raise ActiveRecord::RecordNotFound unless User.find(userid) => 上游做控制I18n控制 => 下游做有效性控制
    RechargeTrade.transaction do
      # build trade
      @trade = RechargeTrade.new(
      	userid: userid,
      	total_amount: amount,
      	remark: remark
      )
      raise StandardError, "订单创建异常: " + @trade.errors.full_messages.first unless @trade.save
      # build payment
      payment = Payment.new(
      	success: false,
      	trade_no: @trade.trade_no,
      	pay_type: pay_type
      )
      raise StandardError, "订单支付记录创建异常: " + payment.errors.full_messages.first unless payment.save
      # update trade
      @trade.update(payment_id: payment.id)
    end
    @trade.trade_no
  end
	
end	
 