class AddPasoActualToFacturacions < ActiveRecord::Migration[7.1]
  def change
    add_column :facturacions, :paso_actual, :integer
  end
end
