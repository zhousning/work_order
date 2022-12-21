class WorkorderCtg < ActiveRecord::Base






  has_many :work_orders, :dependent => :destroy
  accepts_nested_attributes_for :work_orders, reject_if: :all_blank, allow_destroy: true



end
