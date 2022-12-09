class Relate < ActiveRecord::Base
  belongs_to :template


end

# == Schema Information
#
# Table name: relates
#
#  id          :integer         not null, primary key
#  relate_type :string
#  obj         :string
#  template_id :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

