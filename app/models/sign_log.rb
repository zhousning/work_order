class SignLog < ActiveRecord::Base

  mount_uploader :avatar, EnclosureUploader






  belongs_to :worker



end
