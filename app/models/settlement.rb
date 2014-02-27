class Settlement < ActiveRecord::Base

	belongs_to :group
	belongs_to :owed, class_name: 'User'
	belongs_to :owes, class_name: 'User'

  def confirm_settlement=(val)
    if val == 'true'
      self.confirm = true
      self.save
      # call function if everyone confirmed reopen the group
      if self.group.all_group_settlements_confirmed?
        self.group.open
        self.group.save
      end
    end
    
  end


end
