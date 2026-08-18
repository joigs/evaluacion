class CreateInformes < ActiveRecord::Migration[7.1]
  def change
    create_table :informes do |t|
      t.string  :mandante_rut,    null: false
      t.string  :mandante_nombre, null: false
      t.date    :fecha
      t.integer :month
      t.integer :year
      t.integer :n_informes,     null: false, default: 0
      t.decimal :valor_unitario, precision: 12, scale: 2, null: false, default: 0
      t.decimal :total,          precision: 14, scale: 2, null: false, default: 0

      t.timestamps
    end

    add_index :informes, [:year, :month]
    add_index :informes, :mandante_rut
  end
end