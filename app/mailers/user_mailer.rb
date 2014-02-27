class UserMailer < ActionMailer::Base
  #self.async = true
  def welcome_email(user)
    @user = user
    @url  = 'http://wdiexpense.herokuapp.com'
    mail(to: @user.email, subject: 'Welcome to WDI Expense App')
  end

  def contact_mail(params)
  	@params = params
    @url  = 'http://wdiexpense.herokuapp.com'
    mail(to: params[:email], subject: 'Thanks for the feedback on WDI Expense App')
  end

  def feedback_mail(params)
    @params = params
    email = 'stalin.pranava@gmail.com'
    @url  = 'http://wdiexpense.herokuapp.com'
    mail(to: "#{email}", subject: 'Feedback for WDI Expense App')
  end


  def group_signin_notify(group,user)
    email = user.email
    @group = group
    @user = user
    mail(to: "#{email}", subject: 'WDI Expense App Signin Invitation')
  end

  def group_signup_notify(group,email)
    @email = email
    @group = group
    mail(to: "#{email}", subject: 'WDI Expense App Signup Invitation')
  end

  def group_destroy_notify(group,user)
    @user = user
    @group = group
    mail(to: "#{@user.email}", subject: 'WDI Expense App Signup Invitation')
  end

  def group_settlement_notify(user,user2,owed_balance,group)
    @user = user
    @user2 = user2
    @owed_balance = owed_balance
    @group = group
    mail(to: "#{@user2.email}", subject: 'WDI Expense Settlement Sheet')
  end

end