module SpidersHelper

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

  def options_for_spider_category
    {
      Setting.selectors.categories.text.info => Setting.selectors.categories.text.value,
      Setting.selectors.categories.attr.info => Setting.selectors.categories.attr.value,
      Setting.selectors.categories.img.info => Setting.selectors.categories.img.value
    }
  end
end  
