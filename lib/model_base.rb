module ModelBase
  

  def store_unique_number
    if self.idnumber == ""
      self.idnumber = self.class.to_s + "+" + Time.now.to_i.to_s + "%04d" % [rand(10000)]
    end
  end

  def add_count(value)
    self.update_attribute :count, (self.count + value)
  end
  
  def pend
    update_attribute :status, Setting.systems.pending
  end

  def pass
    update_attribute :status, Setting.systems.passed
  end

  def reject
    update_attribute :status, Setting.systems.rejected
  end

end
