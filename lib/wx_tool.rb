require 'restclient'

module WxTool
  def wexin_token
    url = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=" + ENV['WX_APPID'] + "&secret=" + ENV['WX_SECRET'] 
    @wexin = Deploy.find_by_name('weixin')
    now = Time.now
    access_token = '' 
    if !@wexin.key && now - @wexin.start_time < @wexin.expire 
      access_token = @wexin.key 
    else
      RestClient.get(url) do |response|
        body = JSON.parse(response.body)
        errcode = body['errcode']
        if errcode != 0 
          access_token = body['access_token']
          expire = body['expires_in']
          @wexin.update_attributes!(:key => access_token, :expire => expire)
        end
      end
    end
    return access_token 
  end

  def send_msg(openid, number, time, dept, state, content)
    token = wexin_token
    url = "https://api.weixin.qq.com/cgi-bin/message/subscribe/send?access_token=" + token 
    msg = {
      touser: openid,
      template_id: ENV['WX_TEMPLATE'],
      page: "pages/index/index",
      miniprogram_state: "developer",
      lang: "zh_CN",
      data: {
          character_string2: {
              value: number 
          },
          time5: {
              value: time 
          },
          thing4: {
              value: dept 
          } ,
          thing3: {
              value: state 
          } ,
          thing1: {
              value: content 
          }
      }
    } 
    body = {}
    RestClient.post(url, msg.to_json) do |response|
      body = JSON.parse(response.body)
    end

    flag = body['errcode'] == 0 ? true : false
    flag
  end
end
#respond_to do |f|
#  f.json{ render :json => {:state => 'error', :message => '消息发送失败' + body['errmsg']}.to_json}
#end
