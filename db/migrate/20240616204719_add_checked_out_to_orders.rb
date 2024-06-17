class AddCheckedOutToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :checked_out, :boolean, default: false
  end
end
