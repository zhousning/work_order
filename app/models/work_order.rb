class WorkOrder < ActiveRecord::Base
  belongs_to :order_ctg
  belongs_to :factory

  has_many :order_logs, :dependent => :destroy
  has_many :wx_users, :through => :order_logs

  has_many :enclosures, :dependent => :destroy
  accepts_nested_attributes_for :enclosures, reject_if: :all_blank, allow_destroy: true

  has_many :attachments, :dependent => :destroy
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true



  STATESTR = %w(opening assign processing transfer awaiting unsettled completed)
  STATE = [Setting.states.opening, Setting.states.assign, Setting.states.processing, Setting.states.transfer, Setting.states.awaiting, Setting.states.unsettled, Setting.states.completed]
  validates_inclusion_of :state, :in => STATE
  state_hash = {
    STATESTR[0] => Setting.states.opening, 
    STATESTR[1] => Setting.states.assign, 
    STATESTR[2] => Setting.states.processing, 
    STATESTR[3] => Setting.states.transfer, 
    STATESTR[4] => Setting.states.awaiting, 
    STATESTR[5] => Setting.states.unsettled, 
    STATESTR[6] => Setting.states.completed
  }

  STATESTR.each do |state|
    define_method "#{state}?" do
      self.state == state_hash[state]
    end
  end

  def assign 
    update_attribute :state, Setting.states.assign
  end

  def processing 
    update_attribute :state, Setting.states.processing
  end

  def transfer 
    update_attribute :state, Setting.states.transfer
  end

  def awaiting 
    update_attribute :state, Setting.states.awaiting
  end

  def unsettled 
    update_attribute :state, Setting.states.unsettled
  end

  def completed
    update_attribute :state, Setting.states.completed
  end

  before_save :store_unique_number
  def store_unique_number
    if self.number == ""
      self.number = Time.now.to_i.to_s + "%02d" % [rand(100)]
    end
  end


end
