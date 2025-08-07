class AddFechaToOtros < ActiveRecord::Migration[7.1]
  def change
    add_column :otros, :fecha, :date
  end
end
