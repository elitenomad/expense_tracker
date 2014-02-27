class ChangeConfirmAndCreateColumnIntoSettlementsTable < ActiveRecord::Migration
    change_table :settlements do |t|
      t.change :confirm, :boolean, default: false
      t.datetime :settle_at
    end

end
