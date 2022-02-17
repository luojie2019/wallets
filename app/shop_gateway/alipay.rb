require 'cgi'
require 'digest/md5'

module ShopGateway
  module Alipay
    TYPE = 'alipay'
    SETTING_KEYS = 'partner|seller_email|key'
    SETTING_KEYS_CHS = '合作者身份ID|卖家支付宝帐号|安全校验码'

    class Helper
      CURRENCY = %w{CNY}
      CURRENCY_FOREX  = %w{AUD CAD CHF CNY EUR GBP HKD JPY SGD USD}
      SERVER_URL = 'https://mapi.alipay.com/gateway.do?'
      # https://opendocs.alipay.com/open/270/106759

      #service
      CREATE_DIRECT_PAY_BY_USER = 'create_direct_pay_by_user'
      CREATE_PARTNER_TRADE_BY_BUYER = 'create_partner_trade_by_buyer'
      TRADE_CREATE_BY_BUYER = 'trade_create_by_buyer'
      CREATE_FOREIGN_TRADE = 'create_forex_trade'
      AUTH_AUTHORIZE = 'alipay.auth.authorize'
      CREATE_DIRECT_WAP_TRADE = 'alipay.wap.trade.create.direct'
      CREATE_DIRECT_WAP_PAY_BY_USER='alipay.wap.create.direct.pay.by.user'
      FOR_EX='create_forex_trade'
      MOBILE_FOR_EX = 'create_forex_trade_wap'

      # 方法说明
      #
      # @param 参数说明
      # @return [返回数据类型] 返回说明
      def self.chs_keys
        '合作者身份ID|卖家支付宝帐号|安全校验码'
      end

      # 支付成功返回
      #
      # @param 参数说明
      # @return [返回数据类型] 返回说明
      def self.success_response(success_redirect)
        'success'
      end

      # 支付
      #
      # @param 参数说明
      # @return [返回数据类型] 返回说明
      def self.transaction(pay_type, options)
        transaction = SimpleTransaction.new
        transaction.gateway_type = pay_type
        transaction.params = options.clone
        # build service
        options[:_input_charset] = 'utf-8'
        options[:service] = CREATE_DIRECT_PAY_BY_USER # 暂支持即时到账
        # build expired_time
        expired_after = 1440
        if options[:expired_at] && options[:created_at]
          expired_after = ((Time.parse(options[:expired_at]) - Time.parse(options[:created_at])) / 60).to_i
        end
        options[:it_b_pay] = "#{expired_after}m"
        # build signature
        temp_options = options.clone
        to_sign = temp_options.delete_if { |k, v| v.nil? || v.to_s.empty? }.sort.map { |option| "#{option[0].to_s}=#{CGI.unescape(option[1].to_s)}" }.join('&') + options[:key]
        signature = Digest::MD5.hexdigest(to_sign)
        options[:sign] = signature
        options[:sign_type] = 'MD5'
        # for test
        transaction.to_sign = to_sign
        transaction.signature = signature
        # build pay_info
        transaction.url = SERVER_URL + options.delete_if { |k, v| v.nil? || v.to_s.empty? }.map { |k, v| "#{k}=#{CGI.escape(v.to_s)}" }.join("&")
        # return transaction
        transaction
      end

      # 方法说明
      #
      # @param 参数说明
      # @return [返回数据类型] 返回说明
      def self.refund_transaction(pay_type, params)
        transaction = SimpleTransaction.new
        transaction.gateway_type = pay_type
        transaction.params = params.clone
        params[:detail_data] = params[:data].map { |item| "#{item[:gateway_trade_no]}^#{to_double_float(item[:amount])}^#{item[:reason]}" }.join('#')

        service = params.delete(:version) == 3 ? 'refund_fastpay_by_platform_nopwd' : 'refund_fastpay_by_platform_pwd'

        options = {
          service: service,
          :partner => params[:settings][:partner],
          :seller_email => params[:settings][:seller_email],
          :notify_url => params[:notify_url],
          :"_input_charset" => 'utf-8',
          :refund_date => params[:refund_date],
          :batch_no => params[:batch_no],
          :batch_num => params[:data].count,
          :detail_data => params[:detail_data]
        }
        # capture for signature
        temp_options = options.clone
        # build signature
        to_sign = temp_options.delete_if { |k, v| v.nil? || v.to_s.empty? }.sort.map { |option| "#{option[0].to_s}=#{CGI.unescape(option[1].to_s)}" }.join('&') + params[:settings][:key]
        signature = Digest::MD5.hexdigest(to_sign)
        options[:sign] = signature
        options[:sign_type] = 'MD5'

        # for test
        transaction.to_sign = to_sign
        transaction.signature = signature

        # build pay_info
        transaction.url = SERVER_URL + options.delete_if { |k, v| v.nil? || v.to_s.empty? }.map { |k, v| "#{k}=#{CGI.escape(v.to_s)}" }.join("&")

        # return transaction
        transaction
      end

      # 回调
      #
      # @param 参数说明
      # @return [返回数据类型] 返回说明
      def self.notification(pay_type, settings, params={})
        # initialize
        notification = SimpleNotification.new
        notification.gateway_type = pay_type
        notification.raw = params.to_s
        notification.out_trade_no = params[:out_trade_no]
        notification.trade_no = params[:trade_no]
        notification.status = params[:trade_status]
        notification.complete = ['TRADE_FINISHED', 'TRADE_SUCCESS', 'WAIT_SELLER_SEND_GOODS', 'WAIT_BUYER_CONFIRM_GOODS'].include?(params[:trade_status])
        notification.pending = (params[:trade_status] == 'WAIT_BUYER_PAY')
        # build signature
        temp_params = params.clone
        sign_type = temp_params.delete("sign_type") || temp_params.delete(:sign_type)
        signature = temp_params.delete("sign") || temp_params.delete(:sign)
        md5_string = temp_params.to_hash.sort.collect do |s|
          unless s[0] == "notify_id"
            begin
              s[0]+"="+CGI.unescape(s[1])
            rescue Exception => e
              err_raiser(Exception.new("invalid byte sequence in UTF-8, key & value is: #{s[0]}_______#{s[1]}"))
            end
          else
            s[0]+"="+s[1]
          end
        end
        to_sign = md5_string.join("&") + settings[:key]
        # for test
        notification.to_sign = to_sign
        notification.signature = signature
        # verify
        unless signature.nil?
          notification.acknowledge = true if Digest::MD5.hexdigest(to_sign) == signature.downcase
        end
        # return notification
        notification
      end

      # 发货
      #
      # @param 参数说明
      # @return [返回数据类型] 返回说明
      def self.good_delivery(params={})
        transaction = SimpleTransaction.new
        transaction.gateway_type = 'alipay_partner'

        # initialize
        options = {
          :partner => params[:settings][:partner],
          :trade_no => params[:trade_no],
          :logistics_name => params[:logistics_name],
          :invoice_no => params[:invoice_no],
          :transport_type => params[:transport_type],
          :"_input_charset" => 'utf-8',
          :service => 'send_goods_confirm_by_platform'
        }

        # capture for signature
        temp_options = options.clone
        # build signature
        to_sign = temp_options.delete_if { |k, v| v.nil? || v.to_s.empty? }.sort.map { |option| "#{option[0].to_s}=#{CGI.unescape(option[1].to_s)}" }.join('&') + params[:settings][:key]
        signature = Digest::MD5.hexdigest(to_sign)
        options[:sign] = signature
        options[:sign_type] = 'MD5'

        # for test
        transaction.to_sign = to_sign
        transaction.signature = signature

        # build pay_info
        transaction.url = SERVER_URL + options.delete_if { |k, v| v.nil? || v.to_s.empty? }.map { |k, v| "#{k}=#{CGI.escape(v)}" }.join("&")

        # return transaction
        transaction
      end

      # 快捷登陆
      #
      # @param 参数说明
      # @return [返回数据类型] 返回说明
      def self.fast_login(params={})
        transaction = SimpleTransaction.new

        # initialize
        options = {
          :partner => params[:settings][:partner],
          :"_input_charset" => 'utf-8',
          :service => 'alipay.auth.authorize',
          :return_url => params[:return_url],
          :target_service => 'user.auth.quick.login'
        }

        # capture for signature
        temp_options = options.clone
        # build signature
        to_sign = temp_options.delete_if { |k, v| v.nil? || v.to_s.empty? }.sort.map { |option| "#{option[0].to_s}=#{CGI.unescape(option[1].to_s)}" }.join('&') + params[:settings][:key]
        signature = Digest::MD5.hexdigest(to_sign)
        options[:sign] = signature
        options[:sign_type] = 'MD5'

        # for test
        transaction.to_sign = to_sign
        transaction.signature = signature

        # build pay_info
        transaction.url = SERVER_URL + options.delete_if { |k, v| v.nil? || v.to_s.empty? }.map { |k, v| "#{k}=#{CGI.escape(v)}" }.join("&")

        # return transaction
        transaction
      end


    end
  end
end