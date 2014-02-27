class ExpensesController < ApplicationController
  include PortionsHelper  
  
  before_action :set_expense, only: [:show, :edit, :update, :destroy]

  # GET /expenses
  # GET /expenses.json
  def index
    # this gets all the groups the current user is a member of
    @groups = current_user.groups
    # array to hold all the expenses
    @all_expenses = []
    # iterate through each group and then sum up all expenses
    @groups.each do |group|
      group.expenses.current.each do |expense|
        @all_expenses << expense
      end
    end

  end

  # GET /expenses/1
  # GET /expenses/1.json
  def show
    @payer = @expense.payer
    @group = Group.find_by_id @expense.group_id
  end

  # GET /expenses/new
  def new
    @group = Group.find(params[:group_id])
    @expense = @group.expenses.new
    @payer = current_user
  end

  # GET /expenses/1/edit
  def edit
    @group = @expense.group
    @payer = @expense.payer
  end

  # POST /expenses
  # POST /expenses.json
  def create
    @group = Group.find(params[:group_id])
    @expense = @group.expenses.new(expense_params)

    respond_to do |format|
      if @expense.save
        format.html { redirect_to @group, notice: 'Expense was successfully created.' }
        format.json { render action: 'show', status: :created, location: @expense }
      else
        format.html { render action: 'new' }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expenses/1
  # PATCH/PUT /expenses/1.json
  def update
    respond_to do |format|
      if @expense.update(expense_params)
        format.html { redirect_to @group, notice: 'Expense was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expenses/1
  # DELETE /expenses/1.json
  def destroy
    @group = @expense.group
    @expense.destroy
    respond_to do |format|
      format.html { redirect_to group_expenses_url(@group) }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = Expense.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def expense_params
      params.require(:expense).permit(:description, :amount, :user_id)
    end
end
