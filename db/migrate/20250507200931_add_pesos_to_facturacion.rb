class AddPesosToFacturacion < ActiveRecord::Migration[7.1]
  def change
    add_column :facturacions, :pesos, :float
  end
end
