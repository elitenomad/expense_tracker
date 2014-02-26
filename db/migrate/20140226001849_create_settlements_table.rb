class CreateSettlementsTable < ActiveRecord::Migration
  def change
    create_table :settlements do |t|
      t.references :owed, index: true
      t.references :owes, index: true
      t.decimal :payment
      t.references :group, index: true
      t.boolean :confirm
    end
  end
end
