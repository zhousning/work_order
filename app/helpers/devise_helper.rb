module DeviseHelper
  def devise_error_messages!
    return '' if resource.errors.empty?

    messages = (resource.errors.messages.map do |key, value|
      (value.map {|e| content_tag(:li, e)}).join
    end).join
    #messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join

    html = <<-HTML
    <div class="alert alert-danger alert-block error-msg-ctn"> <button type="button"
    class="close" data-dismiss="alert">x</button>
      #{messages}
    </div>
    HTML

    html.html_safe
  end
end
