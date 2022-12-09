class RolePermissionship < ActiveRecord::Base
  belongs_to :role
  belongs_to :permission
end

# == Schema Information
#
# Table name: role_permissionships
#
#  id            :integer         not null, primary key
#  role_id       :integer
#  permission_id :integer
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#

