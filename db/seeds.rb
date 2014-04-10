# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


#user1 = User.create(name: "Barry")
# #User Creation
# user = User.create(:email => 'g.t@hp.com', :password => 'password', :password_confirmation => 'password')

# #User Owner Group creation
# mygroup = user.mygroups.create(name:'Dinner')

# #User groups
# group = user.groups.create(name:'Travel')

# #User Expenses
# myexp = mygroup.expenses.new
# myexp.description="Beer"
# myexp.amount=1000
# myexp.save

# #Expense Portions
# mypor = myexp.portions.new
# mypor.amount=400
# mypor.payee_id=user.id
# mypor.save

#user Portions

wdi3_emails = %w(alberto.forn@gmail.com fede.tagliabue@gmail.com marcus.hoile@gmail.com lukru489@gmail.com peters.sammyjo@gmail.com emacca@me.com stalin.pranava@gmail.com eduard.fastovski@gmail.com ltfschoen@gmail.com cptnmrgn10@gmail.com lukemesiti@gmail.com)

wdi3_emails.each do |email|
  first_part = email[/[^@]+/]
  first_part = first_part.split('').map do |letter|
    if letter.match(/\A[\w]+\z/)
      letter
    else
      ''
    end
  end.join('')

  User.create(
    email: email,
    name: first_part,
    password: 'changeme',
    password_confirmation: 'changeme'
  )
end
