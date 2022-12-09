class Worker < ActiveRecord::Base

  #mount_uploader :avatar, EnclosureUploader

  #mount_uploader :idfront, EnclosureUploader

  #mount_uploader :idback, EnclosureUploader


  has_many :sign_logs, :dependent => :destroy

  before_save :store_unique_number
  def store_unique_number
    if self.number == ""
      self.number = Time.now.to_i.to_s + "%04d" % [rand(10000)]
    end
  end

  STATE = [Setting.states.ongoing, Setting.states.completed, Setting.states.canceled, Setting.states.processing, Setting.states.deleting, Setting.states.error]
  validates_inclusion_of :state, :in => STATE

  def ongoing 
    update_attribute :state, Setting.states.ongoing
  end

  def completed
    update_attribute :state, Setting.states.completed
  end

  def canceled
    update_attribute :state, Setting.states.canceled
  end

  def processing 
    update_attribute :state, Setting.states.processing
  end

  def deleting 
    update_attribute :state, Setting.states.deleting
  end

  def error 
    update_attribute :state, Setting.states.error
  end
end
