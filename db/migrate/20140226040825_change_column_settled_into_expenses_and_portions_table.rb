class ChangeColumnSettledIntoExpensesAndPortionsTable < ActiveRecord::Migration
  def change
    change_table :expenses do |t|
      t.change :settled, :boolean, default: false
    end

    change_table :portions do |t|
      t.change :settled, :boolean, default: false
    end

  end
end
