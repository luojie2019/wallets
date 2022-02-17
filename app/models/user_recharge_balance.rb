class UserRechargeBalance < ApplicationRecord

	scope :not_deleted, -> { where(is_deleted: false) }

  validates_numericality_of :income, greater_than: 0

  IncomeTypeDesc = "收入"
  ExpenditureTypeDesc = "支出"
  
	# 添加收入
  #
  # @param [integer] userid 用户
  # @param [decimal] amount 金额
  # @param [string] remark 备注
  # @return [string] trade_no 订单号
  def self.add_income(userid, amount, remark)
    user_recharge_balance = UserRechargeBalance.create({
        :userid => userid,
        :type_desc => UserRechargeBalance::IncomeTypeDesc,
        :income => amount,
        :remark => remark,
        :serial_no => 'ser'
      })
      user = User.find_by(userid: userid)
      # user.lock!
      user.recharge_finance += amount
      user.save
      user_recharge_balance
    end
end	
 