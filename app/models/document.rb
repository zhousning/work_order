class Document < ActiveRecord::Base
  belongs_to :mth_pdt_rpt

  validates :status, :presence => true,
                     :numericality => {:only_integer => true}

end


# == Schema Information
#
# Table name: documents
#
#  id             :integer         not null, primary key
#  title          :string          default(""), not null
#  html_link      :string          default(""), not null
#  status         :integer         default("0"), not null
#  mth_pdt_rpt_id :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

