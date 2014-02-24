class ExpensesController < ApplicationController
  include PortionsHelper  
  
  before_action :set_expense, only: [:show, :edit, :update, :destroy]
  
  after_action :generate_potions, only: [:create, :update]

  # GET /expenses
  # GET /expenses.json
  def index
    @expenses = Expense.all
    @group = Group.find(params[:group_id])

  end

  # GET /expenses/1
  # GET /expenses/1.json
  def show
    @payer = @expense.payer
  end

  # GET /expenses/new
  def new
    @expense = Expense.new
    @payer = current_user
    @group = Group.find(params[:group_id])
  end

  # GET /expenses/1/edit
  def edit
    @group = @expense.group
    @payer = @expense.payer
  end

  # POST /expenses
  # POST /expenses.json
  def create
    @expense = Expense.new(expense_params)

    respond_to do |format|
      if @expense.save
        format.html { redirect_to @expense, notice: 'Expense was successfully created.' }
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
        format.html { redirect_to @expense, notice: 'Expense was successfully updated.' }
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

    def generate_portions
      portions_helper.generate_portion(@expense)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = Expense.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def expense_params
      params.require(:expense).permit(:description, :amount, :group_id, :user_id)
    end
end
