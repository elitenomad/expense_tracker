class Group < ActiveRecord::Base

	belongs_to :owner, class_name: 'User'
	has_and_belongs_to_many :users
	has_many :expenses

	validates :name, presence: true
end