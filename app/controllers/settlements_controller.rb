class SettlementsController < ApplicationController


	# when group owner requests setllement payments are calculated
	# settlement grabs the user balance of each member
	# members who are owed have negative balances
	# members who owe have positive balances
	# create hashes for owed and owes {user_id: balance}

  def update
    settlement = Settlement.find params[:id]
    group = Group.find params[:group_id]
    settlements = group.settlements.where("settle_at = ? AND owed_id = ?", settlement.settle_at, settlement.owed.id)
    
    settlements.each do |settlement|
      settlement.update(settlement_params)
    end

    # if settlement.update(settlement_params)
      redirect_to group_path(group), notice: 'Settlements are successfully updated.' 
    # else
    #   redirect_to group_path(group), notice: 'Impossible to update settlements.' 
    # end
  end

  def settlement_params
    params.require(:settlement).permit(:confirm_settlement)
  end
end