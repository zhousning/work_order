class Role < ActiveRecord::Base
  has_many :role_permissionships, :dependent => :destroy
  has_many :permissions, :through => :role_permissionships
  has_and_belongs_to_many :users, :join_table => :users_roles

  belongs_to :department
  belongs_to :resource,
             :polymorphic => true
             #:optional => true

  validates :resource_type,
            :inclusion => { :in => Rolify.resource_types },
            :allow_nil => true

  scopify
  
  def set_permissions(permissions)
    if permissions 
      self.permissions = Permission.where(:id => permissions)
    end
  end
end



# == Schema Information
#
# Table name: roles
#
#  id            :integer         not null, primary key
#  name          :string          default(""), not null
#  level         :string          default(""), not null
#  resource_id   :integer
#  resource_type :string
#  department_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

