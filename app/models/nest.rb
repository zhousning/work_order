class Nest < ActiveRecord::Base

  has_many :properties, :dependent => :destroy
  accepts_nested_attributes_for :properties, reject_if: :all_blank, allow_destroy: true

  belongs_to :template

end

# == Schema Information
#
# Table name: nests
#
#  id          :integer         not null, primary key
#  name        :string          default(""), not null
#  template_id :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

