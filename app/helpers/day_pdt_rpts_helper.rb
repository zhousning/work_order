module DayPdtRptsHelper

  def options_for_my_factory(factories)
    str = ""
    factories.each do |f|
      str += "<option value='" + idencode(f.id).to_s + "'>" + f.name + "</option>"
    end

    raw(str)
  end

  def options_for_supervisors
    str = "<option value='" + Setting.workers.supervisor + "'>" + Setting.workers.supervisor_title + "</option>"
    str += "<option value='" + Setting.workers.manager + "'>" + Setting.workers.manager_title + "</option>"
    raw(str)
  end

  def options_for_factories
    str = ""
    Factory.all.each do |f|
      str += "<option value='" + idencode(f.id).to_s + "'>" + f.name + "</option>"
    end

    raw(str)
  end

  def options_for_quotas
    str = ""
    quotas = Quota.all
    quotas.each do |f|
      title = f.name.gsub(/在线-|化验-/, '')
      str += "<option value='" + f.code.to_s + "'>" + title + "</option>"
    end

    raw(str)
  end

  def options_for_device_state
    [
      [Setting.devices.state_normal, Setting.devices.state_normal],
      [Setting.devices.state_repair, Setting.devices.state_repair],
      [Setting.devices.state_stop, Setting.devices.state_stop]
    ]
  end

  def options_for_mudfcts(factory)
    hash = Hash.new
    mudfcts = factory.mudfcts
    mudfcts.each do |f|
      hash[f.name] = f.id.to_s
    end
    hash
  end

  def mudfcts_hash(factory)
    hash = Hash.new
    mudfcts = factory.mudfcts
    mudfcts.each do |f|
      hash[f.id.to_s] = f.name
    end
    hash
  end

  def options_for_years
    year = Time.new.year
    str = ""
    years = (2019..year).to_a.reverse
    years.each do |year|
      str += "<option value='" + year.to_s + "'>" + year.to_s + "</option>"
    end

    raw(str)
  end

  def options_for_mth_months
    str = ""
    months.each_pair do |k, v|
      str += "<option value='" + k + "'>" + v + "</option>"
    end
    raw(str)
  end

  def options_for_workorder_ctg(workorder_ctgs, qes)
    str = ""
    workorder_ctgs.each do |f|
      selected = qes.id.nil? || qes.workorder_ctg.nil? ? '' : qes.workorder_ctg.id
      if f.id == selected
        str += "<option selected='selected' value='" + idencode(f.id).to_s + "'>" + f.name + "</option>"
      else
        str += "<option value='" + idencode(f.id).to_s + "'>" + f.name + "</option>"
      end
    end

    raw(str)
  end


  def options_for_companies(factory)
    str = ""
    Company.all.each do |f|
      selected = factory.id.nil? || factory.company.nil? ? '' : factory.company.id
      if f.id == selected
        str += "<option selected='selected' value='" + idencode(f.id).to_s + "'>" + f.name + "</option>"
      else
        str += "<option value='" + idencode(f.id).to_s + "'>" + f.name + "</option>"
      end
    end

    raw(str)
  end
end  
