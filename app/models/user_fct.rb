class UserFct < ActiveRecord::Base
  belongs_to :user
  belongs_to :factory
end

# == Schema Information
#
# Table name: user_fcts
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  factory_id :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

