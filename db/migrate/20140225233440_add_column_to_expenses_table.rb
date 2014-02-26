class AddColumnToExpensesTable < ActiveRecord::Migration
  def change
    add_column :expenses, :settled, :boolean
  end
end
