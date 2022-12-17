class OrderLog < ActiveRecord::Base
  belongs_to :work_order
  belongs_to :wx_user


  has_many :enclosures, :dependent => :destroy
  accepts_nested_attributes_for :enclosures, reject_if: :all_blank, allow_destroy: true


  has_many :attachments, :dependent => :destroy
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  STATESTR = %w(unaccept accept processed transfer)
  STATE = [Setting.states.unaccept, Setting.states.accept, Setting.states.processed, Setting.states.transfer]
  validates_inclusion_of :state, :in => STATE
  state_hash = {
    STATESTR[0] => Setting.states.unaccept, 
    STATESTR[1] => Setting.states.accept, 
    STATESTR[2] => Setting.states.processed, 
    STATESTR[3] => Setting.states.transfer
  }

  STATESTR.each do |state|
    define_method "#{state}?" do
      self.state == state_hash[state]
    end
  end

  def accept 
    update_attribute :state, Setting.states.accept
    self.work_order.processing
  end

  def unaccept 
    update_attribute :state, Setting.states.unaccept
  end

  def processed 
    update_attribute :state, Setting.states.processed
    self.work_order.processed
  end

  def transfer 
    update_attribute :state, Setting.states.transfer
  end

end
