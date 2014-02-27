module GroupsHelper
	
  def content(user,amount)
	  if (amount > 0)
        @user_balance_hash[user] = content_tag(:strong, amount.round(2),class:'text-success')
      else
        @user_balance_hash[user] = content_tag(:strong, amount.round(2),class:'text-danger')
      end
	end

    def show_balance(amount)
    if (amount >= 0)
        content_tag(:strong, amount.round(2),class:'text-success')
      else
        content_tag(:strong, amount.round(2),class:'text-danger')
      end
  end

	
end
