module GroupsHelper
	def content(user,amount)
	  if (amount > 0)
        @user_portions_hash[user] = content_tag(:strong, amount,class:'text-success')
      else
        @user_portions_hash[user] = content_tag(:strong, amount,class:'text-danger')
      end
	end
end
