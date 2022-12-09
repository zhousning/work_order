class User < ActiveRecord::Base
  rolify
  dragonfly_accessor :qr_code

  has_one :account

  has_many :consumes
  has_many :orders
  has_many :statistics

  has_many :user_fcts, :dependent => :destroy
  has_many :factories, :through => :user_fcts

  has_many :user_depts, :dependent => :destroy
  has_many :departments, :through => :user_depts

  belongs_to :role
  belongs_to :company

  #has_many :users
  #belongs_to :parent,   :class_name => 'User'
  #has_many   :children, :class_name => 'User', :foreign_key => 'parent_id'

  validates_uniqueness_of :phone

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def email_required?
    false
  end

  #before_create :build_default_data
  #def build_default_data
  #  #build_account
  #end

  before_save :store_unique_number
  def store_unique_number
    if self.number == ""
      self.number = Time.now.to_i.to_s + "%04d" % [rand(10000)]
    end
  end

  #after_create :assign_data
  #def assign_data
  #  @archive = Archive.new(:name => Time.now.strftime("%Y") + "工作材料", :user => self)
  #  @archive.portfolios << Portfolio.new(:name => "公文文件", :archive => @archive)
  #  @archive.portfolios << Portfolio.new(:name => "工作计划", :archive => @archive)
  #  @archive.portfolios << Portfolio.new(:name => "会议记录", :archive => @archive)
  #  @archive.portfolios << Portfolio.new(:name => "学习总结", :archive => @archive)
  #  @archive.save
  #  MeterStandard.create!(:user => self)
  #end

  #after_create :set_qrcode
  #def set_qrcode
  #  invite_link = Rails.application.routes.url_helpers.new_user_registration_url(:host => Setting.systems.host, :inviter=>self.number)
  #  qr_code_img = RQRCode::QRCode.new(invite_link).to_img.resize(300, 300)
  #  update_attribute :qr_code, qr_code_img.to_string
  #end

  #STATUS = %w(opening, pending, rejected, passed)
  #STATUS_CODE = %w(0, 1, 2, 3)
  ##validates_inclusion_of :status, :in => STATUS_CODE

  #STATUS.each do |status|
  #  define_method "#{status}?" do
  #    self.status == Setting.users.status
  #  end
  #end

  #def state
  #  if self.status == Setting.users.opening
  #    Setting.users.opening_title
  #  elsif self.status == Setting.users.pending
  #    Setting.users.pending_title
  #  elsif self.status == Setting.users.rejected
  #    Setting.users.rejected_title
  #  elsif self.status == Setting.users.passed
  #    Setting.users.passed_title
  #  end
  #end

  def produce_authc
    update_attribute :authc_number, Time.now.to_i.to_s + "%04d" % [rand(10000)]
  end

  def user_status(value)
  end

  def pend
    update_attribute :status, Setting.users.pending
  end

  def pass
    update_attribute :status, Setting.users.passed
  end

  def reject
    update_attribute :status, Setting.users.rejected
  end

  #不要将assign_default_role放在rolify之前,不然会被执行两次
  after_create :assign_default_role

  def super_admin?
    self.has_role? Setting.roles.super_admin
  end

  def set_roles(roles)
    self.roles = Role.where(:id => roles)
  end

  #def set_profile
  #  #TODO将以下资料标validate先关掉了,如果打开会无法新建
  #  cpt = nil
  #  if self.has_role?(Setting.roles.labour)
  #    cpt = build_labour
  #  elsif self.has_role?(Setting.roles.supervisor)
  #    cpt = build_supervisor
  #  elsif self.has_role?(Setting.roles.constructor)
  #    cpt = build_constructor
  #  elsif self.has_role?(Setting.roles.prospector)
  #    cpt = build_prospector
  #  elsif self.has_role?(Setting.roles.designer)
  #    cpt = build_designer
  #  elsif self.has_role?(Setting.roles.monitor)
  #    cpt = build_monitor_co
  #  elsif self.has_role?(Setting.roles.agentor)
  #    cpt = build_agentor_co
  #  end
  #  cpt.save!
  #  CptDepUser.create!(:cpt_id => cpt.idnumber, :dep_id => cpt.idnumber, :user_id => self.id)
  #end

  def assign_default_role
    #self.add_role Setting.roles.buyer
  end

  #def create_tree_leaf
  #  Tree.create(:user => self)
  #  Leaf.create(:user => self)
  #end
end


# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string          default(""), not null
#  phone                  :string          default(""), not null
#  name                   :string          default(""), not null
#  identity               :string          default(""), not null
#  alipay                 :string          default(""), not null
#  status                 :integer         default("0"), not null
#  number                 :string          default(""), not null
#  authc_number           :string
#  qr_code_uid            :string
#  inviter                :string          default(""), not null
#  encrypted_password     :string          default(""), not null
#  parent_id              :integer
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  role_id                :integer
#  company_id             :integer
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#

