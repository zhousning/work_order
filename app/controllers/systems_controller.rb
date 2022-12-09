require 'restclient'
require 'json'

class SystemsController < ApplicationController
  #TODO 暂时将数据存在cookie中，但前台可以查看，有泄漏的风险
  def send_confirm_code
    if user_signed_in?
      prepare_send('buy_time', 'buy_count', 'buy_code', current_user.phone)
    else
      prepare_send('reg_time', 'reg_count', 'reg_code', params[:phone])
    end
  end

  private

    def prepare_send(time, count, code, phone)
      cfm_code = rand(999999).to_s
      if session[time].nil? || session[time] + 1800 < Time.now
        body = send_work(cfm_code, phone)
        if body["status"] == "0"
          session[time] = Time.now
          session[count] = 1
          cookies[code] = { :value => cfm_code, :expires => 10.minute.from_now }
          render :text => 'success'
        else
          render :text => 'error'
        end
      elsif session[time] + 60 <= Time.now && session[count] < 5 
        body = send_work(cfm_code, phone)
        if body["status"] == "0"
          session[time] = Time.now
          session[count] += 1
          cookies[code] = { :value => cfm_code, :expires => 10.minute.from_now }
          render :text => 'success'
        else
          render :text => 'error'
        end
      end
    end

    def send_work(value, phone)
      url = 'http://api.jisuapi.com/sms/send'
      content = '尊敬的会员，您的验证码:' + value + '。您正在注册，10分钟内有效。'
      data = {
        mobile: phone, 
        content: content,
        appkey: 'd52de3f3ebff6184'
      }
      response = RestClient.get url, params: data, :accept => :json
      body = JSON.parse(response.body)
    end
end
