class WorkOrder < ActiveRecord::Base
  belongs_to :factory
  belongs_to :workorder_ctg

  has_many :order_logs, :dependent => :destroy
  has_many :wx_users, :through => :order_logs

  has_many :enclosures, :dependent => :destroy
  accepts_nested_attributes_for :enclosures, reject_if: :all_blank, allow_destroy: true

  has_many :attachments, :dependent => :destroy
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  has_many :task_logs



  before_save :store_unique_number
  def store_unique_number
    if self.number == ""
      self.number = Time.now.to_i.to_s + "%02d" % [rand(100)]
    end
  end

  after_create :build_default_data
  def build_default_data
    TaskLog.create!(:work_order => self)
  end

  def assign(wx_user_id) 
    TaskLog.create!(:work_order => self, :wx_user_id => wx_user_id, :state => Setting.states.assign)
    OrderLog.create!(:work_order => self, :wx_user_id => wx_user_id, :state => Setting.states.unaccept)
  end

  def processing(wx_user_id) 
    TaskLog.create!(:work_order => self, :wx_user_id => wx_user_id, :state => Setting.states.processing)
  end

  def transfer(wx_user_id) 
    TaskLog.create!(:work_order => self, :wx_user_id => wx_user_id, :state => Setting.states.transfer)
    OrderLog.create!(:work_order => self, :wx_user_id => wx_user_id, :state => Setting.states.unaccept)
  end

  def awaiting(wx_user_id) 
    TaskLog.create!(:work_order => self, :wx_user_id => wx_user_id, :state => Setting.states.awaiting)
  end

  def unsettled(wx_user_id) 
    TaskLog.create!(:work_order => self, :wx_user_id => wx_user_id, :state => Setting.states.unsettled)
  end

  def completed
    self.update_attributes!(:state => Setting.states.completed)
    TaskLog.create!(:work_order => self, :state => Setting.states.completed)
  end

  def processed(wx_user_id)
    TaskLog.create!(:work_order => self, :wx_user_id => wx_user_id, :state => Setting.states.processed)
  end

end
