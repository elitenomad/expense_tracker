class CreatePortions < ActiveRecord::Migration
  def change
    create_table :portions do |t|
      t.decimal :amount
      t.integer :expenses_id
      t.integer :payee_id

      t.timestamps
    end
  end
end
