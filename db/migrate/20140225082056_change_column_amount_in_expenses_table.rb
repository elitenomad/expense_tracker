class ChangeColumnAmountInExpensesTable < ActiveRecord::Migration
  def self.up
    change_column :expenses, :amount, :decimal
  end

  def self.down
  end
end
