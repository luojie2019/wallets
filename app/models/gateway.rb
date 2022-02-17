class Gateway < ApplicationRecord

  TYPE = {
    :alipay => {:helper => 'ShopGateway::Alipay::Helper', :chn_desc => '支付宝'},
    :alipay_qrcode => {:helper => 'ShopGateway::Alipay::Helper', :chn_desc => '支付宝（即时到帐-二维码）'},
    :alipay_forex => {:helper => 'ShopGateway::Alipay::Helper', :chn_desc => '支付宝（境外支付）'},
    :alipay_mforex => {:helper => 'ShopGateway::Alipay::Helper', :chn_desc => '支付宝（境外支付-手机网站）'}
  }

  # 支付
  #
  # @param 参数说明
  # @return [返回数据类型] 返回说明
  def self.transaction(type, option={})
    gateway = Gateway::TYPE[type.to_sym]
    ShopGateway.class_from_string(gateway[:helper]).transaction(type, option)
  end

end	
 