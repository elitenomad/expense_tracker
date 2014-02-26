class AddColumnToPortionsTable < ActiveRecord::Migration
  def change
    add_column :portions, :settled, :boolean
  end
end
