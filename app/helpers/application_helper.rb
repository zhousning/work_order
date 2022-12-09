module ApplicationHelper
  def image_tag(source, options={})
    super(source, options) if source.present?
  end

  def iconic(source)
    return "iconic/" + source + ".svg"
  end

  def form_error_messages!(resource)
    return '' if resource.errors.empty?

    messages = (resource.errors.messages.map do |key, value|
      (value.map {|e| content_tag(:li, e)}).join
    end).join

    html = <<-HTML
    <div class="alert alert-danger alert-block"> <button type="button"
    class="close" data-dismiss="alert">x</button>
      #{messages}
    </div>
    HTML

    html.html_safe
  end

  def format_to_html(str)
    result = ""
    str.split(/\n/).each do |s|
      result += "<p>" + s +"</br></p>"
    end
    result.html_safe
  end

  def idencode(value)
    (value.to_i*99 + 4933)*3 
  end

  def iddecode(value)
    (value.to_i/3 - 4933)/99 
  end

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
end
