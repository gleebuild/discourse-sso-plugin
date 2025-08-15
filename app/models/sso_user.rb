# discourse-sso-plugin/app/models/sso_user.rb
class SsoUser < ActiveRecord::Base
  include LogManager

  validates :phone, presence: true, uniqueness: true
  validates :openid, uniqueness: true, allow_nil: true

  def self.find_or_create_by_phone(phone)
    user = find_by(phone: phone)
    return user if user

    LogManager.log("创建新用户: phone=#{phone}", :info)
    create(phone: phone)
  end

  def link_wechat(openid)
    update!(openid: openid)
    LogManager.log("微信绑定成功: phone=#{phone}, openid=#{openid}")
  end
end