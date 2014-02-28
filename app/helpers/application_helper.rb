module ApplicationHelper
	def fa_icon(name)
	  content_tag(:div, '', class: "service-icon fa fa-#{name}")
  end
end
