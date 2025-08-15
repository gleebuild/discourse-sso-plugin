# discourse-sso-plugin/plugin.rb
name "Discourse-SSO-Plugin"
version "1.0"
author "SSO-Team"

enabled_site_setting :sso_enabled

register_asset 'assets/javascripts/wechat-pay.js'

after_initialize do
  require_dependency 'lib/log_manager'
  require_dependency 'app/controllers/sso_controller'
  require_dependency 'app/controllers/wechat_controller'
  require_dependency 'app/controllers/sms_controller'
  
  # 初始化日志
  LogManager.init(log_file: "#{Rails.root}/log/sso_plugin.log")
end