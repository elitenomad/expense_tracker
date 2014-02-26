class Settlement < ActiveRecord::Base

	belongs_to :group
	belongs_to :owed, class_name: 'User'
	belongs_to :owes, class_name: 'User'

end
