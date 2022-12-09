#传入的必须是纯数字
module FormulaLib
  #s.is_a?(Number)
  
  #处理水量指进水量
  def self.format_num(a)
    a.blank? ? 0 : format("%0.2f", a).to_f
  end

  def self.multiply(a, b)
    a.blank? || b.blank? ? 0 : format("%0.2f",a*b).to_f
  end

  #进水
  def self.ratio(a, b)
    b == 0 ? 0 : format("%0.2f",a/b).to_f
  end

  #同比%
  def self.yoy(current, last)
    last == 0 ? 0 : format("%0.2f", (current-last)/last*10*10).to_f
  end

  #同比%
  def self.mom(current, last)
    last == 0 ? 0 : format("%0.2f", (current-last)/last*10*10).to_f
  end

  #消减率(单位%, 指标mg/l, 水量m3 or 吨)
  def self.emr(quota_in, quota_out)
    quota_in == 0 ? 0 : format("%0.2f",(quota_in - quota_out)/quota_in*10*10).to_f
  end

  #平均消减率(单位%, 消减量吨, 水量m3 or 吨)
  #消减量之和/单指标*处理水量之和
  def self.avg_emr(quota_emq_sum, quota_inflow_sum)
    quota_inflow_sum == 0 ? 0 : format("%0.2f", (quota_emq_sum/quota_inflow_sum*1000000*10*10)).to_f
  end

  #消减量(单位吨, 指标mg/l, 处理水量m3 or 吨)
  #单位若是吨需除1000000 单位若是mg/l不用除1000000
  #(进水-出水)*污水日处理量
  def self.emq(quota_in, quota_out, inflow)
    format("%0.2f",(quota_in - quota_out)*inflow/1000000).to_f
  end

  #平均消减量(单位mg/l, 日削减量吨, 日处理水量m3 or 吨)
  #日削减量和/日处理水量和
  def self.avg_emq(quota_emq_sum, inflow_sum)
    inflow_sum == 0 ? 0 : format("%0.2f",(quota_emq_sum/inflow_sum)*1000000).to_f
  end

  #电单耗(单位kw.h/m3, 电量kw.h, 进水量m3)
  def self.bom(power, inflow)
    inflow == 0 ? 0 : format("%0.2f",power/inflow).to_f
  end

  #消减电单耗(单位kw.h/kg, 电量kw.h, 指标mg/l, 进水量m3)
  def self.em_bom(power, quota_in, quota_out, inflow) 
    (quota_in - quota_out != 0 && inflow !=0) ? format("%0.2f",power*1000/(quota_in - quota_out)/inflow).to_f : 0
  end

  #药剂投加浓度
  #药剂量*药剂浓度/污水处理量
  def self.dosptc(dosage, cmptc, inflow)
    inflow == 0 ? 0 : format("%0.2f", dosage*cmptc/inflow*10000).to_f
  end

  #吨水药剂成本(元/千吨)
  #药剂单价*投加量/污水处理量
  def self.chemical_per_cost(unprice, dosage, inflow)
    inflow == 0 ? 0 : format("%0.2f", unprice*dosage/inflow*1000).to_f
  end

  #偏差率
  def self.std_dev(act, theory)
    theory == 0 ? 0 : format("%0.2f",(act - theory)/theory*10*10).to_f
  end

end
