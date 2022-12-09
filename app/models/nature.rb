class Nature < ActiveRecord::Base
  belongs_to :template


end


# == Schema Information
#
# Table name: natures
#
#  id          :integer         not null, primary key
#  name        :string
#  data_type   :string
#  title       :string
#  tag         :string
#  required    :boolean
#  template_id :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

