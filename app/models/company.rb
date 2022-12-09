class Company < ActiveRecord::Base

  mount_uploader :logo, EnclosureUploader






  has_many :users, :dependent => :destroy
  accepts_nested_attributes_for :users, reject_if: :all_blank, allow_destroy: true


  has_many :factories, :dependent => :destroy
  accepts_nested_attributes_for :factories, reject_if: :all_blank, allow_destroy: true



end

# == Schema Information
#
# Table name: companies
#
#  id         :integer         not null, primary key
#  area       :string          default(""), not null
#  name       :string          default(""), not null
#  info       :text
#  lnt        :string          default(""), not null
#  lat        :string          default(""), not null
#  logo       :string          default(""), not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

