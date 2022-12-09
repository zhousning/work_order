class WorkerDestroy
  include Sidekiq::Worker

  def perform(worker_id)
    sleep(2)
    @worker = Worker.find(worker_id)
    url = "https://aip.baidubce.com/rest/2.0/face/v3/faceset/user/delete?access_token=" + ENV['ACCESS_TOKEN']
    params = {
      group_id: Setting.systems.face_group,
      user_id: @worker.idno,
    }
    body = request_baidu_destroy(url, params)
    if body['error_code'] != 0 && body['error_code'] != 223103 && body['error_code'] != 222018
      @worker.canceled
      @worker.update_attributes!(:desc => body['error_msg'])
    else
      @worker.destroy
    end
  end

  private
    def request_baidu_destroy(url, params)
      url = url + "?access_token=" + ENV['ACCESS_TOKEN']
      body = nil
      RestClient.post(url, params, {content_type: "application/json;charset=UTF-8"}) do |response|
        body = JSON.parse(response.body)
      end
      body
    end

end
