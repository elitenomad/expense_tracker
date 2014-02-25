class UsersController < ApplicationController
  def index
  	@group = Group.find(params[:id])

  	if params[:name].nil? || params[:name].empty?
      @users = User.all
    else
      term = "%#{params[:name]}%"
      @users = User.where("lower(name) like ? or lower(email) like ? ", term.downcase,term.downcase)
    end
  end
end
