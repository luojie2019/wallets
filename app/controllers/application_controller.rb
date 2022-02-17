class ApplicationController < ActionController::API
  include ActionView::Layouts

  before_action :validate_token
  before_action :required_login

  # 定义JsonResponseError异常
  class JsonResponseError < StandardError
    attr_accessor :code
    attr_accessor :sub_code
    def initialize(code, sub_code, i18n_params = {})
      @code, @sub_code = code, sub_code
      message = I18n.t(sub_code, i18n_params)
      super(message)
    end
  end

  def render_403
    render template: 'layouts/403', layout: '403', status: 403
  end

  # 捕获ActiveRecord
  rescue_from ActiveRecord::RecordInvalid do |err|
    render json: { code: 405, msg: err.record.errors }
  end

  # 捕获其他异常
  rescue_from Exception do |err|
    Rails.logger.info("500 Exception Error :: #{err.message}")
    # MQ推送到日志服务
    render json: { code: ( err.code rescue 500 ), msg: err.message, data: {}}
  end

  # 定义接口返回json数据方法

  private

  def build_json_response(excute_block)
    rs = {}
    begin
      msg_json = {}
      excute_block.call(msg_json)
      rs = {
        :code => 200,
        :msg => '',
        :data => msg_json
      }
    rescue ActiveRecord::RecordNotFound => e
      rs = {
        :code => 404,
        :msg => '记录未找到',
        :data => {},
        :detail => e.message
      }
    rescue ActiveRecord::RecordInvalid => e
      rs = {
        :code => 405,
        :msg => 'ActiveRecord异常',
        :data => {},
        :detail => e.message
      }
    rescue ActionController::ParameterMissing => e
      rs = {
        :code => 501,
        :msg => '参数缺失',
        :data => {},
        :detail => e.message
      }
    rescue StandardError => e
      rs = {
        :code => 502,
        :msg => e.message,
        :data => {}
      }
    rescue JsonResponseError => e
      rs = {
        :code => e.code,
        :msg => e.message,
        :data => {}
      }
    rescue Exception => e
      rs = {
        :code => 500,
        :msg => 'Sorry,服务器遇到小麻烦,刚才的操作没成功',
        :data => {},
        :detail => '系统错误，请联系后端开发人员'
      }
      Raven.capture_exception(e)
      Rails.logger.info("500 system error :: #{e.full_message}")
    end
    render json: Oj.dump(rs, mode: :rails)
  end

  # 其他controller公共方法
  
  def validate_token
    @token = request.headers[:token]
    @token = params[:authToken] unless @token
  end

  def required_login
    raise JsonResponseError.new(202, 'error.user.not_login') if current_user.blank?
  end

  def current_user
    # @current_user ||= JSON.parse(BaseRedisClient.get("seesion_#{@token}")) rescue nil
    @current_user ||= User.find_by_token(@token)
  end

  def default_page(params)
    page = params[:page].to_i rescue 1
    size = params[:size].to_i rescue 10
    page = 1 if page < 1
    size = 10 if size < 1
    [page, size]
  end
  
  def required(*options)
    options.each do |option|
      raise JsonResponseError.new(201, 'error.params.not_null', {:name => option}) if !params.key?(option) || params[option].to_s.empty?
    end
  end

end
