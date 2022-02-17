class Trade < ApplicationRecord
  
  # 创建订单
  def self.create_trade(opts)
    bank_code_id = nil
    if pay_type.include?("|")
      pay_type, bank_code_id = pay_type.split("|")
    end
    case type.to_s.downcase
    when 'create', 'renew', 'levelup'
      trade_no = YeePlanTrade.build_plan_trade(current_account.id, siteid, service_id, quantity, code, pay_type, bank_code_id, type.to_s)
      type = 'plan'
    when 'sms'
      trade_no = YeeSmsTrade.build_sms_trade(current_account.id, siteid, service_id, quantity, code, pay_type, bank_code_id)
    when 'email'
      trade_no = YeeEmailTrade.build_email_trade(current_account.id, siteid, service_id, quantity, code, pay_type, bank_code_id)
    when 'storage'
      trade_no = YeeStorageTrade.build_storage_trade(current_account.id, siteid, service_id, quantity, code, pay_type, bank_code_id)
    when 'recharge'
      trade_no = YeeRechargeTrade.build_recharge_trade(current_account.id, quantity, pay_type, bank_code_id, 1, remark)
    when 'project'
      payment = nil
      raise JsonResponseError.new(201, 'error.service.trade_no_not_exist') unless yee_project_trade = YeeProjectTrade[:trade_no => trade_no, :account_id => current_account.id]
      if YeePayment[:trade_no => trade_no]
        payment = YeePayment[:trade_no => trade_no].update(:pay_type => pay_type.to_i, :bank_code_id => bank_code_id.to_i)
      else
        payment = yee_project_trade.build_payment(pay_type, bank_code_id)
      end
      raise JsonResponseError.new(201, 'error.service.plan_trade_create_fail') if payment.to_s.empty?
    else
      raise JsonResponseError.new(201, 'error.service.service_not_exist')
    end
    raise JsonResponseError.new(201, 'error.store.plan_trade_create_fail') if trade_no.to_s.empty?
    # pay_url = URI.join(Setting_Domain, "/payment/pay_trade/#{type}/#{trade_no}").to_s
    pay_url = "payment/pay_trade/#{type}/#{trade_no}"
    pay_url
  end

end
