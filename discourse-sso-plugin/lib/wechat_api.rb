# discourse-sso-plugin/lib/wechat_api.rb
class WechatApi
  class AuthError < StandardError; end

  include LogManager

  APP_ID = ENV['WECHAT_APP_ID']
  APP_SECRET = ENV['WECHAT_SECRET']

  def self.get_access_token(code)
    uri = URI("https://api.weixin.qq.com/sns/oauth2/access_token")
    params = {
      appid: APP_ID,
      secret: APP_SECRET,
      code: code,
      grant_type: 'authorization_code'
    }
    uri.query = URI.encode_www_form(params)
    
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body)
  end

  def self.get_user_info(code)
    token_data = get_access_token(code)
    raise AuthError, token_data['errmsg'] if token_data['errcode']

    uri = URI("https://api.weixin.qq.com/sns/userinfo")
    params = {
      access_token: token_data['access_token'],
      openid: token_data['openid'],
      lang: 'zh_CN'
    }
    uri.query = URI.encode_www_form(params)
    
    response = Net::HTTP.get_response(uri)
    user_info = JSON.parse(response.body, symbolize_names: true)
    
    {
      openid: user_info[:openid],
      nickname: user_info[:nickname],
      avatar: user_info[:headimgurl]
    }
  end
end