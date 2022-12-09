class Notice < ActiveRecord::Base

  has_many :enclosures, :dependent => :destroy
  accepts_nested_attributes_for :enclosures, reject_if: :all_blank, allow_destroy: true


end


# == Schema Information
#
# Table name: notices
#
#  id         :integer         not null, primary key
#  title      :string          default(""), not null
#  content    :text
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

