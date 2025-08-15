# discourse-sso-plugin/app/controllers/sms_controller.rb
class SmsController < ApplicationController
  include LogManager

  RATE_LIMIT = 60 # 60秒内只能发送一次

  def send_code
    phone = params[:phone]
    
    # 频率限制检查
    if Rails.cache.read("sms_cooldown:#{phone}")
      LogManager.log("短信发送过于频繁: phone=#{phone}", :warn)
      return render json: { error: "请求过于频繁，请稍后再试" }, status: 429
    end

    # 发送短信验证码
    if SmsService.send_code(phone)
      Rails.cache.write("sms_cooldown:#{phone}", true, expires_in: RATE_LIMIT.seconds)
      LogManager.log("短信发送成功: phone=#{phone}")
      render json: { success: true }
    else
      LogManager.log("短信发送失败: phone=#{phone}", :error)
      render json: { error: "短信发送失败" }, status: 500
    end
  end

  def verify_code
    phone = params[:phone]
    code = params[:code]
    stored_code = Rails.cache.read("sms_code:#{phone}")

    if stored_code.to_s == code.to_s
      # 创建或查找用户
      user = SsoUser.find_or_create_by_phone(phone)
      session[:current_user_id] = user.id
      
      LogManager.log("短信验证成功: phone=#{phone}")
      render json: { 
        success: true, 
        redirect_url: SsoController.generate_redirect_url(user)
      }
    else
      LogManager.log("短信验证失败: phone=#{phone}, 输入=#{code}, 正确=#{stored_code}", :warn)
      render json: { error: "验证码错误" }, status: 401
    end
  end
end