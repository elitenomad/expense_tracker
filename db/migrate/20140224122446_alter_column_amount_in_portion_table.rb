class AlterColumnAmountInPortionTable < ActiveRecord::Migration
  def self.up
    change_column :portions, :amount, :decimal
  end

  def self.down
  end
end
