module ApplicationHelper	

  def set_focus id
  	result =
    '<script type="text/javascript">' +
       "$('##{id}').focus();" +
    '</script>'
    result.html_safe
  end
end
