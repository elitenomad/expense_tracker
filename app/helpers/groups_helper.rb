module GroupsHelper
	def content(user,amount)
	  if (amount > 0)
        @user_portions_hash[user] = content_tag(:strong, amount.round(2),class:'text-success')
      else
        @user_portions_hash[user] = content_tag(:strong, amount.round(2),class:'text-danger')
      end
	end

	
end
