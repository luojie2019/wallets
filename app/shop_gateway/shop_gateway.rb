require "alipay"

module ShopGateway
  TYPE = {
    :alipay => {:helper => 'ShopGateway::Alipay::Helper', :chn_desc => '支付宝'},
    :alipay_qrcode => {:helper => 'ShopGateway::Alipay::Helper', :chn_desc => '支付宝（即时到帐-二维码）'}
  }

  # TODO 改到存储到db里
  SETTINGS = {
    alipay: {
      partner: {
        chs_key: '合作者身份ID'
      },
      seller_email: {
        chs_key: '卖家支付宝帐号'
      },
      key: {
        chs_key: '安全校验码'
      }
    },

    alipay_qrcode: {
      partner: {
        chs_key: '合作者身份ID'
      },
      seller_email: {
        chs_key: '卖家支付宝帐号'
      },
      key: {
        chs_key: '安全校验码'
      }
    },
    :alipay_forex => {
      partner: {
        chs_key: '合作者身份ID'
      },
      key: {
        chs_key: '安全校验码'
      }
    },
    alipay_mforex: {
      partner: {
        chs_key: '合作者身份ID'
      },
      key: {
        chs_key: '安全校验码'
      }
    },
    alipay_bank: {
      partner: {
        chs_key: '合作者身份ID'
      },
      seller_email: {
        chs_key: '卖家支付宝帐号'
      },
      key: {
        chs_key: '安全校验码'
      }
    },
    alipay_partner: {
      partner: {
        chs_key: '合作者身份ID'
      },
      seller_email: {
        chs_key: '卖家支付宝帐号'
      },
      key: {
        chs_key: '安全校验码'
      }
    },
    alipay_wap_user: {
      partner: {
        chs_key: '合作者身份ID'
      },
      seller_email: {
        chs_key: '卖家支付宝帐号'
      },
      key: {
        chs_key: '安全校验码'
      }
    },
    tenpay: {
      partner: {
        chs_key: '商户号'
      },
      key: {
        chs_key: '密钥'
      }
    },
    tenpay_bank: {
      partner: {
        chs_key: '商户号'
      },
      key: {
        chs_key: '密钥'
      }
    },
    :kuaipay => {
      merchant_acct_id: {
        chs_key: '帐号（MerchantAcctID）'
      },
      key: {
        chs_key: '密钥'
      }
    },
    unionpay: {
      mer_id: {
        chs_key: '商户代码'
      },
      private_pfx: {
        chs_key: '商户私钥证书（.pfx）'
      },
      private_password: {
        chs_key: '私钥证书密码'
      },
      public_cer: {
        chs_key: '银联公钥证书（.cer）'
      }
    },
    wppay: {
      mer_id: {
        chs_key: '商户号'
      },
      appid: {
        chs_key: 'APPID'
      },
      key: {
        chs_key: 'API密钥'
      },
      appsecret: {
        chs_key: '应用密钥'
      }
    },
    wppay_app: {
      mer_id: {
        chs_key: '商户号'
      },
      appid: {
        chs_key: 'APPID'
      },
      key: {
        chs_key: 'API密钥'
      }
    },
    qfpay: {
      mchnt_id: {
        chs_key: '子商户号(钱台)'
      },
      out_mchnt: {
        chs_key: '子商户号'
      }
    },
    qfpay_wpqr: {
      mchnt_id: {
        chs_key: '子商户号(钱台)'
      },
      out_mchnt: {
        chs_key: '子商户号'
      }
    },
    baifubao: {
      sp_no: {
        chs_key: '商户ID'
      },
      key: {
        chs_key: '百付宝合作密钥'
      }
    },
    paypal: {
      client_id: {
        chs_key: 'Client Id'
      },
      secret: {
        chs_key: 'Secret'
      }
    },
    dinpay: {
      merchant_code: {
        chs_key: '商户代码'
      },
      dinpay_public_key: {
        chs_key: '智付公钥'
      },
      public_key: {
        chs_key: '公钥'
      }

    },
    srpay:{
      merchant_code:{
        chs_key:'商户代码'
      },
      key:{
        chs_key:'密钥'
      }
    },
    paydollar:{
      mer_id:{
        chs_key:'商家代号'
      }
    },
    offline:{

    },
    custom_alipay: {
      partner: {
        chs_key: '合作者身份ID'
      },
      seller_email: {
        chs_key: '卖家支付宝帐号'
      },
      key: {
        chs_key: '安全校验码'
      }
    },
    custom_alipay_wap_user: {
      partner: {
        chs_key: '合作者身份ID'
      },
      seller_email: {
        chs_key: '卖家支付宝帐号'
      },
      key: {
        chs_key: '安全校验码'
      }
    },
    custom_wppay: {
      mer_id: {
        chs_key: '商户号'
      },
      appid: {
        chs_key: 'APPID'
      },
      key: {
        chs_key: 'API密钥'
      },
      appsecret: {
        chs_key: '应用密钥'
      }
    },
    nihaopay_unionpay:{
      token:{
        chs_key:'商家Token'
      }
    },
    nihaopay_alipay:{
      token:{
        chs_key:'商家Token'
      }
    },
    nihaopay_wechatpay:{
      token:{
        chs_key:'商家Token'
      }
    },
  }

  # 方法说明
  #
  # @param 参数说明
  # @return [返回数据类型] 返回说明
  def self.class_from_string(str)
    str.split('::').inject(Object) do |mod, class_name|
      mod.const_get class_name
    end
  end

  # 方法说明
  #
  # @param 参数说明
  # @return [返回数据类型] 返回说明
  def self.settings(pay_type)
    ShopGateway::SETTINGS[pay_type.to_sym]
  end

  # 方法说明
  #
  # @param 参数说明
  # @return [返回数据类型] 返回说明
  def self.currencies(type)
    return ['CNY'] if type=='alipay_app'
    return Alipay::Helper::CURRENCY_FOREX if type=='alipay_forex' || type=='alipay_mforex'
    gateway = ShopGateway::TYPE[type.to_sym]
    ShopGateway.class_from_string(gateway[:helper]).const_get(:CURRENCY)
  end

  # 支付网关配置对应中文描述
  #
  # @param 参数说明
  # @return [返回数据类型] 返回说明
  def self.chs_keys(type)
    return '货到付款' if type.to_s == 'offline'
    return '合作者身份ID|安全校验码' if type.to_s=='alipay_forex' || type.to_s=='alipay_mforex'
    return '商户号|应用ID|商户平台API密钥' if type.to_s=='wppay_app'
    gateway = ShopGateway::TYPE[type.to_sym]
    ShopGateway.class_from_string(gateway[:helper]).chs_keys
  end

  # 异步回调支付成功后返回的通知格式
  #
  # @param 参数说明
  # @return [返回数据类型] 返回说明
  def self.success_response(type, url)
    gateway = ShopGateway::TYPE[type.to_sym]
    ShopGateway.class_from_string(gateway[:helper]).success_response(url)
  end

  # 支付
  #
  # @param 参数说明
  # @return [返回数据类型] 返回说明
  def self.transaction(type, option={})
    gateway = ShopGateway::TYPE[type.to_sym]
    ShopGateway.class_from_string(gateway[:helper]).transaction(type, option)
  end

  # 方法说明
  #
  # @param 参数说明
  # @return [返回数据类型] 返回说明
  def self.check_refund(type,option={})
    gateway = ShopGateway::TYPE[type.to_sym]
    ShopGateway.class_from_string(gateway[:helper]).check_refund(type, option)
  end

  # 方法说明
  #
  # @param 参数说明
  # @return [返回数据类型] 返回说明
  def self.refund_transaction(type, option={})
    gateway = ShopGateway::TYPE[type.to_sym]
    ShopGateway.class_from_string(gateway[:helper]).refund_transaction(type, option)
  end

  # 交易查询
  #
  # @param 参数说明
  # @return [返回数据类型] 返回说明
  def self.query(type, option={})
    gateway = ShopGateway::TYPE[type.to_sym]
    ShopGateway.class_from_string(gateway[:helper]).query(type, option)
  end

  # 支付回调和交易查询回调
  #
  # @param 参数说明
  # @return [返回数据类型] 返回说明
  def self.notification(type, settings, params={})
    gateway = ShopGateway::TYPE[type.to_sym]
    ShopGateway.class_from_string(gateway[:helper]).notification(type, settings, params)
  end

  # 方法说明
  #
  # @param 参数说明
  # @return [返回数据类型] 返回说明
  def self.refund_notification(type, params={})
    gateway = ShopGateway::TYPE[type.to_sym]
    ShopGateway.class_from_string(gateway[:helper]).refund_notification(type, settings, params)
  end

  # 担保交易 发货
  #
  # @param 参数说明
  # @return [返回数据类型] 返回说明
  def self.good_delivery(params={})
    ShopGateway::Alipay::Helper.good_delivery(params)
  end

  # 支付宝快捷登陆
  #
  # @param 参数说明
  # @return [返回数据类型] 返回说明
  def self.fast_login(params={})
    ShopGateway::Alipay::Helper..fast_login(params)
  end

  # 微信 统一下单
  #
  # @param 参数说明
  # @return [返回数据类型] 返回说明
  def self.unifie_order_transaction(params={})
    ShopGateway::WPpay::Helper.unifie_order_transaction(params)
  end

  # 微信JSAPI支付
  #
  # @param 参数说明
  # @return [返回数据类型] 返回说明
  def self.jsapi_transaction(params={})
    ShopGateway::WPpay::Helper.jsapi_transaction(params)
  end

  class SimpleTransaction

    # 字段说明
    # @return [类型] 详细说明
    attr_accessor :gateway_type

    # 字段说明
    # @return [类型] 详细说明
    attr_accessor :http_method

    # 字段说明
    # @return [类型] 详细说明
    attr_accessor :url

    # 字段说明
    # @return [类型] 详细说明
    attr_accessor :params

    # 字段说明
    # @return [类型] 详细说明
    attr_accessor :params_xml

    # 字段说明
    # @return [类型] 详细说明
    attr_accessor :to_sign

    # 字段说明
    # @return [类型] 详细说明
    attr_accessor :to_sign_sha1

    # 字段说明
    # @return [类型] 详细说明
    attr_accessor :signature

    # 字段说明
    # @return [类型] 详细说明
    attr_accessor :app_params

    # 字段说明
    # @return [类型] 详细说明
    attr_accessor :result

    # 方法说明
    #
    # @param 参数说明
    # @return [返回数据类型] 返回说明
    def initialize
      @gateway_type = ''
      @http_method = :get
      @url = ''
      @params = {}
      @params_xml = ''
      # sepecial for test
      @to_sign = ''
      @to_sign_sha1 = ''
      @signature = ''
    end
  end

  class SimpleNotification
    # 字段说明
    # @return [类型] 详细说明
    attr_accessor :gateway_type

    # 字段说明
    # @return [类型] 详细说明
    attr_accessor :complete

    # 字段说明
    # @return [类型] 详细说明
    attr_accessor :pending

    # 字段说明
    # @return [类型] 详细说明
    attr_accessor :acknowledge

    # 字段说明
    # @return [类型] 详细说明
    attr_accessor :status

    # 字段说明
    # @return [类型] 详细说明
    attr_accessor :out_trade_no

    # 字段说明
    # @return [类型] 详细说明
    attr_accessor :trade_no

    # 字段说明
    # @return [类型] 详细说明
    attr_accessor :raw

    # 字段说明
    # @return [类型] 详细说明
    attr_accessor :to_sign

    # 字段说明
    # @return [类型] 详细说明
    attr_accessor :to_sign_sha1

    # 字段说明
    # @return [类型] 详细说明
    attr_accessor :signature

    def initialize
      @gateway_type = ''
      @complete = false
      @acknowledge = false
      @status = ''
      @out_trade_no = ''
      @trade_no = ''
      @raw = ''
      # sepecial for alipay_partner
      @pending = false
      # sepecial for test
      @to_sign = ''
      @to_sign_sha1 = ''
      @signature = ''
    end
  end
end

