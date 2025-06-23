class AddEmpresaToFacturacions < ActiveRecord::Migration[7.1]
  def change
    add_column :facturacions, :empresa, :string
  end
end
