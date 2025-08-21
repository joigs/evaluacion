class AddTPesosToOtros < ActiveRecord::Migration[7.1]
  def change
    add_column :otros, :t_pesos, :decimal, precision: 15, scale: 2, default: 0, null: false
  end
end
