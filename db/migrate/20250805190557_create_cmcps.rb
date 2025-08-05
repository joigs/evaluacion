class CreateCmcps < ActiveRecord::Migration[7.1]
  def change
    create_table :cmcps do |t|
      t.integer :month
      t.integer :year
      t.integer :numero_servicios
      t.decimal :total_uf, precision: 10, scale: 2

      t.timestamps
    end
  end
end
