class WxWorkersController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  authorize_resource

  def index
  end

  def query_all 
    @wxuser = WxUser.find_by_number(current_user.phone)
    items = Worker.where(:wx_inviter => @wxuser.id).order('created_at DESC').all
   
    obj = []
    items.each do |item|
      obj << {
        :id => idencode(item.id),
        :idno => item.idno,
        :name => item.name,
        :phone => item.phone,
        :gender => user_gender(item.gender),
        :adress => item.adress,
        :fct => Factory.find(item.factory).name
      }
    end
    obj
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end
   
  def query_info 
    #@wxuser = WxUser.find_by_number(current_user.phone)
    #@worker = Worker.find_by_wx_inviter(@wxuser.id)
    @worker = Worker.find(iddecode(params[:id]))
   
    info = [@worker.name, @worker.idno, @worker.phone]
    imgs = []
    @worker.img.split(',').each do |item|
      imgs << item 
    end
    respond_to do |f|
      f.json{ render :json => {:info => info, :img => imgs}.to_json}
    end
  end
   
   
  def signlogs
    @worker = Worker.find(iddecode(params[:id]))
    @sign_logs = @worker.sign_logs.order('created_at DESC') 
    obj = []
    @sign_logs.each do |item|
      wxuser = WxUser.where(:id => item.wx_user_id).first
      obj << {
        :time => item.created_at.strftime('%Y-%m-%d %H:%M:%S'),
        :fzr => wxuser.nil? ? '-' : wxuser.name,
        :zd => Device.find(item.device_id).name,
        :jwd => item.longitude + ', ' + item.latitude,
        :img => item.avatar_url
      }
    end
    obj
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end
  
end

