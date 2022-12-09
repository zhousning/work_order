class Attachment < ActiveRecord::Base
  mount_uploader :file, AttachmentUploader
  belongs_to :dog
  belongs_to :work_order
  belongs_to :order_log
end





# == Schema Information
#
# Table name: attachments
#
#  id         :integer         not null, primary key
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  file       :string          default(""), not null
#

