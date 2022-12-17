module StateModule
  def months
    {
      Setting.months.one    => Setting.months.one_t, 
      Setting.months.two    => Setting.months.two_t, 
      Setting.months.three  => Setting.months.three_t,
      Setting.months.four   => Setting.months.four_t, 
      Setting.months.five   => Setting.months.five_t,
      Setting.months.six    => Setting.months.six_t,
      Setting.months.seven  => Setting.months.seven_t,
      Setting.months.eight  => Setting.months.eight_t,
      Setting.months.nine   => Setting.months.nine_t, 
      Setting.months.ten    => Setting.months.ten_t,
      Setting.months.eleven => Setting.months.eleven_t,
      Setting.months.twelve => Setting.months.twelve_t
    }

  end

  def user_gender(gender)
    flag = ''
    if gender == Setting.systems.man_no
      flag = Setting.systems.man
    else gender == Setting.systems.woman_no
      flag = Setting.systems.woman
    end

  end

  def worker_state(state)
    str = ''
    if state == Setting.states.ongoing
      str = '未验证'
    elsif state == Setting.states.processing
      str = '处理中'
    elsif state == Setting.states.canceled ||  state == Setting.states.error
      str = '处理失败'
    elsif state == Setting.states.deleting
      str = '删除中'
    elsif state == Setting.states.completed
      str = '已验证'
    end
    str
  end

  def order_state(state)
    state_hash = {
      Setting.states.opening    => Setting.state_tags.opening, 
      Setting.states.assign     => Setting.state_tags.assign, 
      Setting.states.processing => Setting.state_tags.processing, 
      Setting.states.transfer   => Setting.state_tags.transfer, 
      Setting.states.awaiting   => Setting.state_tags.awaiting, 
      Setting.states.unsettled  => Setting.state_tags.unsettled, 
      Setting.states.completed  => Setting.state_tags.completed
    }
    state_hash[state]
  end

  def order_log_state(state)
    state_hash = {
      Setting.states.unaccept    => Setting.state_tags.unaccept, 
      Setting.states.accept    => Setting.state_tags.accept, 
      Setting.states.processed    => Setting.state_tags.processed, 
      Setting.states.transfer    => Setting.state_tags.transfer, 
    }
    state_hash[state]
  end

  def file_icon(type) 
    icons = {
      Setting.file_libs.doc => "office/word.svg",
      Setting.file_libs.xls => "office/excel.svg",
      Setting.file_libs.pdf => "office/pdf.svg",
      Setting.file_libs.img => "office/image.svg",
      Setting.file_libs.ppt => "office/ppt.svg",
      Setting.file_libs.mp4 => "office/mp4.svg",
      Setting.file_libs.txt => "office/txt.svg"
    }
    icons[type]
  end                                            
end
