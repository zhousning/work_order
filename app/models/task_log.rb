class TaskLog < ActiveRecord::Base
  belongs_to :work_order

  STATESTR = %w(opening assign processing transfer awaiting unsettled completed processed)
  STATE = [Setting.states.opening, Setting.states.assign, Setting.states.processing, Setting.states.transfer, Setting.states.awaiting, Setting.states.unsettled, Setting.states.completed, Setting.states.processed]
  validates_inclusion_of :state, :in => STATE
  state_hash = {
    STATESTR[0] => Setting.states.opening, 
    STATESTR[1] => Setting.states.assign, 
    STATESTR[2] => Setting.states.processing, 
    STATESTR[3] => Setting.states.transfer, 
    STATESTR[4] => Setting.states.awaiting, 
    STATESTR[5] => Setting.states.unsettled, 
    STATESTR[6] => Setting.states.completed,
    STATESTR[7] => Setting.states.processed 
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

  def processed
    update_attribute :state, Setting.states.processed
  end


end
