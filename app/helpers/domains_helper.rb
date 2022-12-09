module DomainsHelper

  def options_for_content_type
    [
      ["application/x-www-form-urlencoded", "application/x-www-form-urlencoded"]
    ]
  end                                            

  def options_for_agent
    [
      ["chrome", "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/63.0.3239.84 Chrome/63.0.3239.84 Safari/537.36"]
    ]
  end                                            

  def options_for_domain_level(level) 
    levels = [Setting.domains.level_one, Setting.domains.level_two, Setting.domains.level_three]

    str = "<option value='0'>无</option>"
    if !level.nil? && levels.include?(level) 
      str += "<option selected='selected' value='" + level + "'>" + level + "</option>"
    end
    ls = levels.reject do |l|
      l == level
    end
    ls.each do |item|
        str += "<option value='" + item + "'>" + item + "</option>"
    end
    raw(str)
  end

  def options_for_major_level(level) 
    levels = [Setting.majors.level_one, Setting.majors.level_two, Setting.majors.level_three]

    str = "<option value='0'>无</option>"
    if !level.nil? && levels.include?(level) 
      str += "<option selected='selected' value='" + level + "'>" + level + "</option>"
    end
    ls = levels.reject do |l|
      l == level
    end
    ls.each do |item|
        str += "<option value='" + item + "'>" + item + "</option>"
    end
    raw(str)
  end
end  
