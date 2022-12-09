class WebsiteFormBuilder < ActionView::Helpers::FormBuilder

  def div_radio_button(method, tag_value, options = {})
    @template.content_tag(:div,
      @template.radio_button(@object_name, method, tag_value, objectify_options(options))
    )
  end

  def block_subunit_validate(method, tag_value)
    objectify_options(options)[:object].subunit == tag_value.to_s
  end

  def website_page_id
    objectify_options(options)[:object].id
  end

  def index_page_validate
    objectify_options(options)[:object].name == '首页' 
  end

  def enclosure_image
    file = objectify_options(options)[:object].file_url
    file.blank? ? 'logo-grey.png' : file
  end

  def logo_image
    file = objectify_options(options)[:object].logo_url
    file.blank? ? 'logo-grey.png' : file
  end

  def cert_front
    file = objectify_options(options)[:object].cert_front_url
    file.blank? ? 'logo-grey.png' : file
  end

  def cert_back
    file = objectify_options(options)[:object].cert_back_url
    file.blank? ? 'logo-grey.png' : file
  end

  def idcard_front
    file = objectify_options(options)[:object].idcard_front_url
    file.blank? ? 'logo-grey.png' : file
  end

  def idcard_back
    file = objectify_options(options)[:object].idcard_back_url
    file.blank? ? 'logo-grey.png' : file
  end

  def quality_front
    file = objectify_options(options)[:object].quality_front_url
    file.blank? ? 'logo-grey.png' : file
  end

  def quality_back
    file = objectify_options(options)[:object].quality_back_url
    file.blank? ? 'logo-grey.png' : file
  end

  def quality_one_front
    file = objectify_options(options)[:object].quality_one_front_url
    file.blank? ? 'logo-grey.png' : file
  end

  def quality_one_back
    file = objectify_options(options)[:object].quality_one_back_url
    file.blank? ? 'logo-grey.png' : file
  end

  def quality_two_front
    file = objectify_options(options)[:object].quality_two_front_url
    file.blank? ? 'logo-grey.png' : file
  end

  def quality_two_back
    file = objectify_options(options)[:object].quality_two_back_url
    file.blank? ? 'logo-grey.png' : file
  end

  def quality_three_front
    file = objectify_options(options)[:object].quality_three_front_url
    file.blank? ? 'logo-grey.png' : file
  end

  def quality_three_back
    file = objectify_options(options)[:object].quality_three_back_url
    file.blank? ? 'logo-grey.png' : file
  end

  def safe_front
    file = objectify_options(options)[:object].safe_front_url
    file.blank? ? 'logo-grey.png' : file
  end

  def safe_back
    file = objectify_options(options)[:object].safe_back_url
    file.blank? ? 'logo-grey.png' : file
  end

  def append_url 
    file = objectify_options(options)[:object].append_url
    file.blank? ? '选择文件' : File.basename(file)
  end

  def attachment_url 
    file = objectify_options(options)[:object].file_url
    file.blank? ? '选择文件' : File.basename(file)
  end

  def one_image(image)
    url = image + "_url"
    file = objectify_options(options)[:object].nil? ? '' : objectify_options(options)[:object].public_send(url)
    file.blank? ? 'logo-grey.png' : file
  end

  def one_attachment(append) 
    url = append + "_url"
    file = objectify_options(options)[:object].nil? ? '' : objectify_options(options)[:object].public_send(url)
    file.blank? ? '选择文件' : URI.decode(File.basename(file))
  end

  def page_html
    html = objectify_options(options)[:object].html
    html.html_safe
  end

  def page_style
    style = objectify_options(options)[:object].style
    style.html_safe
  end

  def chemical_name
    name = objectify_options(options)[:object].name
    name
  end
end
