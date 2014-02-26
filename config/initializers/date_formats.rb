# whenever dates get manupulated please do
# do datestr.to_s(:default)
Date::DATE_FORMATS[:short] = "%B %e, %Y"
DateTime::DATE_FORMATS[:short] = "%B %e, %Y"
Time::DATE_FORMATS[:short] = "%B %e, %Y"