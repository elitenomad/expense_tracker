class Group < ActiveRecord::Base
belongs_to :owner, :class_name => 'User'

# TODO in user model has relationship with Group: has_many :groups :source => :owner

end
