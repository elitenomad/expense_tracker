class AddColumnToGroupsTable < ActiveRecord::Migration
  def change
    add_column :groups, :status, :string
  end
end
