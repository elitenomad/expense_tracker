# whenever dates get manupulated please do
# do datestr.to_s(:default)
Date::DATE_FORMATS[:default] = "%B %e, %Y"
DateTime::DATE_FORMATS[:default] = "%B %e, %Y"