class CreateOxiesAndConductors < ActiveRecord::Migration[7.1]
  def change
    create_table :oxies do |t|
      t.integer :month
      t.integer :year
      t.integer :numero_conductores
      t.decimal :suma, precision: 10, scale: 2
      t.decimal :total_uf, precision: 10, scale: 2

      t.timestamps
    end

  end
end
