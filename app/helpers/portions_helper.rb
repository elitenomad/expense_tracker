module PortionsHelper

def self.generate_portion(exp)
  sharing_users  = exp.group.users
  portion_amount = exp.amount / sharing_users.count
  sharing_users.each do |user|
    portion = exp.portions.new(expense_id: exp.id, payee_id: user.id, amount: portion_amount)
    portion.save
  end
end



def calculate_percentage_portion_per_user(exp)
  sharing_users = exp.group.users
  # TODO create an array of hash with user and portion(percentage or numeric ?)
  # then in generate portion call this function to calculate each user portion befrore creating portions
end

end
