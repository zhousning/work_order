class Department < ActiveRecord::Base


  belongs_to :factory


  has_many :user_depts, :dependent => :destroy
  has_many :users, :through => :user_depts

  has_many :roles, :dependent => :destroy
  accepts_nested_attributes_for :roles, reject_if: :all_blank, allow_destroy: true



  belongs_to :user

end

# == Schema Information
#
# Table name: departments
#
#  id         :integer         not null, primary key
#  name       :string          default(""), not null
#  info       :text
#  factory_id :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

