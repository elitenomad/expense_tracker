class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Added as per Public_activity gem instruction
  include PublicActivity::StoreController
  # Added as per devise doco instructions
  before_action :authenticate_user!

  before_filter :configure_permitted_parameters, if: :devise_controller?

def current_user_method
  current_user
end

hide_action :current_user_method

private

	def configure_permitted_parameters
	  devise_parameter_sanitizer.for(:sign_up) << :name
	  devise_parameter_sanitizer.for(:account_update) << :name
	end

  def calculate_amount_outstanding(users,group)
    user_portions_hash={}
    users.each do |user|
        exp = user.expenses.current.where(group_id: group.id).sum(:amount)
        port = group.portions.current.where(payee_id: user.id).sum(:amount)
        user_portions_hash[user] = exp - port
      end
      user_portions_hash
  end
end
