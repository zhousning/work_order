class FctWxuser < ActiveRecord::Base
  belongs_to :factory
  belongs_to :wx_user
end
