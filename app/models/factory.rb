class Factory < ActiveRecord::Base
  belongs_to:parent, :class_name => 'Factory'
  has_many :children, :class_name => 'Factory', :foreign_key => 'parent_id', :dependent => :destroy
  accepts_nested_attributes_for :children, reject_if: :all_blank, allow_destroy: true

  mount_uploader :logo, EnclosureUploader

  belongs_to :company

  has_many :work_orders

  has_many :user_fcts, :dependent => :destroy
  has_many :users, :through => :user_fcts

  has_many :fct_wxusers, :dependent => :destroy
  has_many :wx_users, :through => :fct_wxusers

  has_many :departments, :dependent => :destroy
  accepts_nested_attributes_for :departments, reject_if: :all_blank, allow_destroy: true

  after_create :create_account
  def create_account 
    if self.users.blank?
      @role_fct = Role.where(:name => Setting.roles.role_fct).first
      @fctmgn = [@role_fct]

      phone = Time.now.to_i.to_s + "%02d" % [rand(100)]
      User.create!(:phone => phone, :password => phone, :password_confirmation => phone, :name => self.name, :roles => @fctmgn, :factories => [self])
    end
  end

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

