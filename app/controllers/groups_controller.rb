class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # GET /groups
  # GET /groups.json
  def index
    #@groups = Group.all
    @groups = current_user.groups
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @users = @group.users
    # Need to create Users and loop through
    # their respective portions and create a owing amount
    @user_portions_hash = {}
    # amount_owed = 0
    # @users.each do |user|
    #   portions = user.portions
    #   portions.each do |portion|
    #     amount_owed += portion.amount
    #   end
    #   @user_portions_hash[user.name]=amount_owed
    #   # why is amount owed set back to 0?
    #   amount_owed = 0
    # end

    # Calculate Owe and Owed Money
    exp = 0
    port = 0
    @users.each do |user|
      user.expenses.each { |e| exp = exp + e.amount }
      user.portions.each { |p| port = port + p.amount }
      @user_portions_hash[user.name] = exp - port
      exp = 0
      port = 0
    end


    # below is to get all the data for the expense list partial
    # get all the expenses for the current group
    # list in table, expense description, expense amount and link to details page
    @expenses = @group.expenses

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
