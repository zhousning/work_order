class Factory < ActiveRecord::Base

  mount_uploader :logo, EnclosureUploader

  belongs_to :company

  has_many :projects

  has_many :devices
  has_many :upholds
  has_many :tasks

  has_many :user_fcts, :dependent => :destroy
  has_many :users, :through => :user_fcts

  has_many :fct_wxusers, :dependent => :destroy
  has_many :wx_users, :through => :fct_wxusers

  has_many :departments, :dependent => :destroy
  accepts_nested_attributes_for :departments, reject_if: :all_blank, allow_destroy: true


end


# == Schema Information
#
# Table name: factories
#
#  id         :integer         not null, primary key
#  area       :string          default(""), not null
#  name       :string          default(""), not null
#  info       :text
#  lnt        :string          default(""), not null
#  lat        :string          default(""), not null
#  design     :float           default("0.0"), not null
#  plan       :float           default("0.0"), not null
#  logo       :string          default(""), not null
#  company_id :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

