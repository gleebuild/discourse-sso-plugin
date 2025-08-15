# discourse-sso-plugin/app/controllers/sso_controller.rb
class SsoController < ApplicationController
  include LogManager

  def generate_token
    # 参数验证
    phone = params[:phone]
    LogManager.log("SSO请求开始: phone=#{phone}", :info)

    # 生成JWT令牌
    payload = {
      sub: phone,
      exp: 24.hours.from_now.to_i,
      iss: 'discourse_sso'
    }
    token = JWT.encode(payload, ENV['SSO_SECRET'], 'HS256')
    
    # 返回DiscourseConnect兼容负载
    sso_url = "#{SiteSetting.discourse_base_url}/session/sso_login?sso=#{payload}&sig=#{signature}"
    LogManager.log("SSO令牌生成成功: #{token}", :info)
    
    render json: { sso_url: sso_url }
  rescue => e
    LogManager.log("SSO异常: #{e.message}", :error)
    render json: { error: e.message }, status: 500
  end
end