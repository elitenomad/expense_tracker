class RanameEspensesIdColumnIntoPortionsTable < ActiveRecord::Migration
  def self.up
    rename_column :portions, :expenses_id, :expense_id
  end

  def self.down
  end
end
