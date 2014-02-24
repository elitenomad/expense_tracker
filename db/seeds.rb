# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


#user1 = User.create(name: "Barry")
#User Creation
user = User.create(:email => 'g.t@hp.com', :password => 'password', :password_confirmation => 'password')

#User Owner Group creation
mygroup = user.mygroups.create(name:'Dinner')

#User groups
group = user.groups.create(name:'Travel')

#User Expenses
myexp = mygroup.expenses.new
myexp.description="Beer"
myexp.amount=1000
myexp.save

#Expense Portions
mypor = myexp.portions.new
mypor.amount=400
mypor.payee_id=user.id
mypor.save

#user Portions

