class Enclosure < ActiveRecord::Base
  mount_uploader :file, EnclosureUploader

  belongs_to :notice
  belongs_to :article
  belongs_to :website
  belongs_to :page
  belongs_to :block_content
  belongs_to :format
  belongs_to :carousel
  belongs_to :ocr

  belongs_to :day_pdt
  belongs_to :task
  belongs_to :task_report
  belongs_to :work_order
  belongs_to :order_log
end




# == Schema Information
#
# Table name: enclosures
#
#  id         :integer         not null, primary key
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  file       :string          default(""), not null
#  notice_id  :integer
#  article_id :integer
#  ocr_id     :integer
#
