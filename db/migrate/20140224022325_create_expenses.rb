class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.text :description
      t.integer :amount
      t.references :group, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
