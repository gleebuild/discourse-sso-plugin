# discourse-sso-plugin/config/routes.rb
Rails.application.routes.draw do
  # 微信认证路由
  get '/auth/wechat', to: 'wechat#auth'
  get '/auth/wechat/callback', to: 'wechat#callback'
  
  # 短信验证路由
  post '/sms/send', to: 'sms#send_code'
  post '/sms/verify', to: 'sms#verify_code'
  
  # SSO网关路由
  get '/sso/generate', to: 'sso#generate_token'
  
  # 支付绑定路由
  post '/payments/link_openid', to: 'payments#link_openid'
end