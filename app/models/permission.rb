class Permission < ActiveRecord::Base
  has_many :role_permissionships, :dependent => :destroy
  has_many :roles, :through => :role_permissionships
end


# == Schema Information
#
# Table name: permissions
#
#  id            :integer         not null, primary key
#  name          :string          default(""), not null
#  subject_class :string          default(""), not null
#  action        :string          default(""), not null
#  subject_id    :integer         default("0"), not null
#  description   :text
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#

