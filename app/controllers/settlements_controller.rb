class SettlementsController < ApplicationController

	def show
	end
	# when group owner requests setllement payments are calculated
	# settlement grabs the user balance of each member
	# members who are owed have negative balances
	# members who owe have positive balances
	# create hashes for owed and owes {user_id: balance}

  def testing
    if params[:check] == 'open'
      # reopen a settled group
      group = Group.find params[:group_id]
      group.open
      group.save
      redirect_to group
    elsif params[:check] == 'confirm'
      settlement = Settlement.find params[:settlement_id]
      group = Group.find params[:group_id]
      settlement.confirm = true
      settlement.save
      # call function if everyone confirmed reopen the group
      if all_group_settlements_confirmed?(group)
        group.open
        group.save
      end
      redirect_to group
    else
      # settle the group
      group = Group.find params[:group_id]
      group.settle
      group.save
      create_random_settlement(group)
      redirect_to group
    end
  end

  def all_group_settlements_confirmed?(group)
    # if thereis at least 1 false, the function return false, otherwise return true
    check = true
    group.settlements.each do |settlement| 
      if settlement.confirm == false
       check = false
      end
    end
    check
  end

  def create_random_settlement(group)
    time = Time.now.utc
    Settlement.create(owed_id: 1, owes_id: 2, payment: 10, group_id: group.id, settle_at: time)
    Settlement.create(owed_id: 3, owes_id: 2, payment: 10, group_id: group.id, settle_at: time)
  end

	# for first user in hash compare the balance with first user in 2nd hash
	# if 1st > 2nd
	# update 1st user balanceu
	# update 2nd user balance and store 2nd user owes 1st user
	# you need to go to 3rd user
	def create
		@group = Group.find(params[:id])
		@owed = {}
		@owes = {}
		@users = @group.users
    exp = 0
    port = 0
    # calculate the balance of each user
    # this will need to be refactored when balance is added to the group table
    @users.each do |user|
      user.expenses.each { |e| exp = exp + e.amount }
      user.portions.each { |p| port = port + p.amount }
      if exp > port
	      @owed[user.name] = exp - port
	    elsif exp < port
	    	@owes[user.name] = exp - port
	    end
      exp = 0
      port = 0
    end

    # compare balances between owed and owes
    # update balances and create settlements
    @owed.each do |user, balance|
    	# loop user
    	while balance > 0
	    	@owes.each do |user2, balance2|
	    		# if user who is owed has a lower balance, they can be paid in full
	    		if balance < balance2
	    			balance2 = balance2 - balance
	    			balance = 0
	    			puts "owed balance is 0"
	    			# create settlement, 
	    			 Settlement.create(owed_id: user.id, owes_id: user2.id, payment: balance, group_id: @group.id, confirm: false)
	    		elsif balance > balance2
	    			balance = balance - balance2
	    			balance2 = 0
	    			puts "payed balance is 0"
	    			Settlement.create(owed_id: user.id, owes_id: user2.id, payment: balance, group_id: @group.id, confirm: false)
	    		end
    		end
    	end
  	end
	end


end