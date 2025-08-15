# discourse-sso-plugin/lib/sms_service.rb
class SmsService
  include LogManager

  def self.send_code(phone)
    # 频率限制（防攻击）
    return if Rails.cache.read("sms_cooldown:#{phone}")
    
    code = SecureRandom.rand(100000..999999)
    Rails.cache.write("sms_code:#{phone}", code, expires_in: 5.minutes)
    
    # 调用腾讯云API
    response = Typhoeus.post(
      "https://yun.tim.qq.com/v5/tlssmssvr/sendsms",
      body: {
        ext: "",
        extend: "",
        params: [code, "5"],
        sig: calculate_signature(phone),
        sign: "YourBrand",
        tel: { nationcode: "86", mobile: phone },
        time: Time.now.to_i,
        tpl_id: 123456
      }.to_json
    )
    
    LogManager.log("短信发送: phone=#{phone}, code=#{code}, status=#{response.code}")
    response.code == 200
  end
end