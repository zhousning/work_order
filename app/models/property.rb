class Property < ActiveRecord::Base





  belongs_to :nest


end


# == Schema Information
#
# Table name: properties
#
#  id         :integer         not null, primary key
#  name       :string          default(""), not null
#  tag        :string          default(""), not null
#  required   :boolean
#  nest_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

