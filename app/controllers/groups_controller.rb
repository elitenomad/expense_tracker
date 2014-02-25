class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # GET /groups
  # GET /groups.json
  def index
    #@groups = Group.all
    @groups = current_user.mygroups
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @expenses = @group.expenses
    @portions = current_user.portions
    @users = @group.users
    @amount_owing = []
    # push all the portion amounts in to an array
    @portions.each do |portion|
      @amount_owing << portion.amount
    end
    # this adds up all the values in the array
    @amount_owing = @amount_owing.reduce(:+)

    # Need to create Users and loop through
    # their respective portions and create a owing amount
    @user_portions_hash = {}
    amount_owed = 0
    @users.each do |user|
      portions = user.portions
      portions.each do |portion|
        amount_owed += portion.amount
      end
      @user_portions_hash[user.email]=amount_owed
      amount_owed = 0
    end

  end

  # Add users to groups
  def adduser
    @group = Group.find(params[:id])
    # validate if user is present
    # Two conditions arise
    # User in the database. he will be just added to the group
    # User not in the database. If this is the case we need to
    # figure a way out to adjust user in a group
    user_count = User.where(email: params[:emailid]).count
    group_users_count = @group.users.where(email: params[:emailid]).count
    if(user_count >= 1)
      user = User.find_by(email: params[:emailid])
      if (group_users_count == 0)
        @group.users << user
        redirect_to action: 'show'
      else
        redirect_to groupuser_path(@group), alert: "User is already added to group"
      end
    else
        # Need to perform another logic
        fail
    end
    
  end

  # GET /groups/new
  def new
    # @group = Group.new
    @group = current_user.mygroups.new
    @owner = current_user
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = current_user.mygroups.new(group_params)

    respond_to do |format|
      if @group.save
        current_user.groups << @group
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render action: 'show', status: :created, location: @group }
      else
        format.html { render action: 'new' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, :owner_id)
    end
end
