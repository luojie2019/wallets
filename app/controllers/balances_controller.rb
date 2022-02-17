class BalancesController < ApplicationController
   
  # 钱包余额
  #
  # @param -
  # @return [decimal] current_amount 余额
  def index
    excute_block = lambda do |response|
      response[:nick_name] = @current_user.name
      response[:current_amount] = @current_user.recharge_finance
    end
    build_json_response(excute_block) 
  end

  # 充值
  #
  # @param [decimal] amount 充值金额
  # @param [string] pay_type 支付方式
  # @param [string] remark 备注
  # @return [string] pay_url 支付链接
  def recharge
    excute_block = lambda do |response|
      required(:amount, :pay_type, :remark)
      raise JsonResponseError.new(201, 'error.pay_type.not_exist') unless Payment.validate_pay_type(params[:pay_type])
      # 校验amount的有效性：最小值最大值；
      # 校验备注的有效长度：
      response[:trade_no] = RechargeTrade.build_recharge_trade(@current_user.userid, params[:amount], params[:pay_type], params[:remark])
      response[:pay_url] = "#{ENV['PAY_HOST']}payments/pay_trade/#{response[:trade_no]}?authToken=#{@current_user.token}"
    end
    build_json_response(excute_block) 
  end

end
