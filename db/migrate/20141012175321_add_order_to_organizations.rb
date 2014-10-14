class AddOrderToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :order, :integer
  end
end
