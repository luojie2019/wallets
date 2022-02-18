class TransferTrade < ApplicationRecord

  # 状态码
  module Status
    "状态:0init 1expired 2success 3cancel 4deal"
    extend self
    INIT = 0
    EXPIRED = 1
    SUCCESS = 2
    CANCEL = 3
    DEAL = 4
  
    def [](name)
      {
        :"#{0}" => '创建成功',
        :"#{1}" => '交易过期',
        :"#{2}" => '交易成功',
        :"#{3}" => '交易取消',
        :"#{4}" => '交易完成'
      }[name.to_s.to_sym]
    end
  end

	scope :not_deleted, -> { where(is_deleted: false) }

  validates_numericality_of :total_amount, greater_than: 0

  before_create do |item|
    # generate_unique_no => 后期可用一些算法生成
    item.trade_no = SecureRandom.uuid.delete('-').upcase
  end
  
  # 转账订单创建
  #
  # @param [integer] pay_userid 付款用户ID
  # @param [integer] recv_userid 收款账户ID
  # @param [decimal] total_amount 转账金额
  # @param [string] remark 备注
  # @return [string] trade_no 订单号
  def self.build_transfer_trade(pay_userid, recv_userid, total_amount, remark)
    raise ActiveRecord::RecordNotFound unless pay_user = User.find_by(userid: pay_userid)
    raise ActiveRecord::RecordNotFound unless revc_user = User.find_by(userid: recv_userid)
    raise StandardError, '帐号资金不足，无法完成支付' if pay_user.recharge_finance <= 0 || pay_user.recharge_finance < total_amount.to_d
    TransferTrade.transaction do 
      # build trade
      @trade = TransferTrade.new(
        pay_userid: pay_userid,
        recv_userid: recv_userid,
        total_amount: total_amount,
        remark: remark
      )
      raise StandardError, "订单创建异常: " + @trade.errors.full_messages.first unless @trade.save
      # build payment
      payment = Payment.new(
        success: false,
        trade_no: @trade.trade_no,
        pay_type: 'wallets'
      )
      raise StandardError, "订单支付记录创建异常: " + payment.errors.full_messages.first unless payment.save
      @trade.update(payment_id: payment.id)
    end
    @trade.trade_no
  end

end	
 