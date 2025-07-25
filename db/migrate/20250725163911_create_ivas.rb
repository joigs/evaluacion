class CreateIvas < ActiveRecord::Migration[7.1]
  def change
    create_table :ivas do |t|
      t.integer :year,  null: false
      t.integer :month, null: false
      t.decimal :valor, precision: 15, scale: 4, null: false

      t.timestamps
    end
  end
end
