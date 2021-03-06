class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # GET /groups
  # GET /groups.json
  def index
    @groups = current_user.groups.order(created_at: :desc).all
    @group = current_user.groups.new
    @my_balances = {}
    @total_balance = 0
    @groups.each do |group|
      @my_balances[group] = calculate_balance(group,current_user)
      @total_balance = @total_balance + calculate_balance(group,current_user)
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @users = @group.users
    @expense_copy = Expense.new
    @expense = Expense.new

    # need last set of settlement    
    @settlements = @group.settlements
    @oweds = []
    last_set = @group.settlements.order(settle_at: :desc).first
    if last_set.present?
      @settlements = @group.settlements.where('settle_at = ?', last_set.settle_at)
      @oweds = @settlements.map do |s| s.owed end
    end


    # Need to create Users and loop through
    # their respective portions and create a owing amount
    @user_balance_hash = {}
    @user_invested_hash = {}
    @user_portion_hash = {}
    # Calculate Owe and Owed Money
    current_group_id = @group.id
  
   
    #calculate owe and owed column
    @user_balance_hash = calculate_amount_outstanding(@users, @group)

    @users.each do |user|
      expense = user.expenses.current.where(group_id: current_group_id).sum(:amount)
      @user_invested_hash[user.name] = expense
    end

    @users.each do |user|
      portion = @group.portions.current.where(payee_id: user.id).sum(:amount)
      @user_portion_hash[user.name] = portion
    end

    # below is to get all the data for the expense list partial
    # get all the expenses for the current group
    # list in table, expense description, expense amount and link to details page
    @expenses = @group.expenses.current.order(created_at: :desc)
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

        # Added as part of activity feed
        @group.create_activity :create, owner: current_user
        
        format.html { redirect_to group_path(@group), notice: 'Group was successfully created.' }
        format.json { render action: 'show', status: :created, location: group_path(@group) }
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
    # Email Notification for users
    users = @group.users
    users.each do |user|
      UserMailer.group_destroy_notify(@group,user)
    end
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
      params.require(:group).permit(:name, :owner_id, :do_settlement)
    end
end
