class Portion < ActiveRecord::Base

	belongs_to :expense

	belongs_to :payee, class_name: 'User'

end
