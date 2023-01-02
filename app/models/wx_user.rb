# == Schema Information
#
# Table name: wx_users
#
#  id         :integer          not null, primary key
#  unionid    :string           default(""), not null
#  openid     :string           default(""), not null
#  nickname   :string           default(""), not null
#  avatarurl  :string           default(""), not null
#  gender     :string           default(""), not null
#  city       :string           default(""), not null
#  province   :string           default(""), not null
#  country    :string           default(""), not null
#  language   :string           default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class WxUser < ActiveRecord::Base
  has_many :order_logs, :dependent => :destroy
  has_many :work_orders, :through => :order_logs

  has_many :fct_wxusers, :dependent => :destroy
  has_many :factories, :through => :fct_wxusers

 STATESTR = %w(ongoing completed)
  STATE = [Setting.states.ongoing, Setting.states.completed]
  validates_inclusion_of :state, :in => STATE
  state_hash = {
    STATESTR[0] => Setting.states.ongoing, 
    STATESTR[5] => Setting.states.completed
  }

  STATESTR.each do |state|
    define_method "#{state}?" do
      self.state == state_hash[state]
    end
  end

  def ongoing 
    update_attribute :state, Setting.states.ongoing
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
