class SettlementsController < ApplicationController

	def show
	end
	# when group owner requests setllement payments are calculated
	# settlement grabs the user balance of each member
	# members who are owed have negative balances
	# members who owe have positive balances
	# create hashes for owed and owes {user_id: balance}


	# for first user in hash compare the balance with first user in 2nd hash
	# if 1st > 2nd
	# update 1st user balance
	# update 2nd user balance and store 2nd user owes 1st user
	# you need to go to 3rd user
	def create
		@group = Group.find(params[:group_id])
		@owed = {}
		@owes = {}
		@users = @group.users
    exp = 0
    port = 0
    
    # calculate the balance of each user
    # this will need to be refactored when balance is added to the group table
    @users.each do |user|
    	
      expenses = @group.expenses.where(user_id: user)
      expenses.each { |e| exp = exp + e.amount }
      portions = @group.portions.where(payee_id: user)
      portions.each { |p| port = port + p.amount }
      if exp > port
	      @owed[user] = exp - port
	    elsif exp < port
	    	@owes[user] = port - exp
	    end
      exp = 0
      port = 0
    end
    
    # compare balances between owed and owes
    # update balances and create settlements
    @owes.each do |user2, owes_balance|
    	abs_owes_balance = owes_balance.abs
    	
    	# for each user in hash who is owed money take money from users who owe money until balance is even
    	# then delete owed user and take next owed user and iterate
    	begin
	    	user,owed_balance = @owed.first    	
    		# if user who is owed has a lower balance, they can be paid in full
    		if owed_balance == 0						 					  
    			@owed.delete(user)
    			if @owed.count == 0
    				break
    			end   			
    		elsif abs_owes_balance >= owed_balance	 
    			abs_owes_balance = abs_owes_balance - owed_balance    			
    			# create settlement, 
           UserMailer.group_settlement_notify(user,user2,owed_balance,@group).deliver
    			 Settlement.create(owed_id: user.id, owes_id: user2.id, payment: owed_balance, group_id: @group.id, confirm: false)
    			 @owed.delete(user)
    			 if @owed.count == 0
    			 	break
    			 end
    		else 
    			owed_balance = owed_balance - abs_owes_balance  
          UserMailer.group_settlement_notify(user,user2,abs_owes_balance,@group).deliver  	
    			Settlement.create(owed_id: user.id, owes_id: user2.id, payment: abs_owes_balance, group_id: @group.id, confirm: false)
    		  @owed[user] = owed_balance
    		end
    	end 
  	end
  	redirect_to @group
	end

	

end