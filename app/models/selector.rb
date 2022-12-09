class Selector < ActiveRecord::Base
  belongs_to :spider


end

# == Schema Information
#
# Table name: selectors
#
#  id         :integer         not null, primary key
#  name       :string          default(""), not null
#  file       :boolean         default("t"), not null
#  title      :string          default(""), not null
#  category   :string          default(""), not null
#  spider_id  :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

