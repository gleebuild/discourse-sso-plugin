# discourse-sso-plugin/app/controllers/wechat_controller.rb
class WechatController < ApplicationController
  include LogManager

  def callback
    # 获取微信用户数据
    code = params[:code]
    LogManager.log("微信回调接收: code=#{code}", :info)
    
    user_info = WechatApi.get_user_info(code)
    openid = user_info[:openid]
    
    # 绑定支付OpenID（关键步骤）
    SsoUser.find_by(phone: session[:phone]).update!(openid: openid)
    LogManager.log("微信OpenID绑定成功: phone=#{session[:phone]}, openid=#{openid}")
    
    redirect_to SsoService.generate_redirect_url(user_info)
  rescue WechatApi::AuthError => e
    LogManager.log("微信认证失败: #{e.message}", :error)
    render plain: "微信登录失败"
  end
end