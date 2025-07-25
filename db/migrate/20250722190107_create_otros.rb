class CreateOtros < ActiveRecord::Migration[7.1]
  def change
    create_table :otros do |t|
      t.integer :month
      t.integer :year
      t.decimal :n1
      t.decimal :n2
      t.decimal :total
      t.references :empresa, null: false, foreign_key: true

      t.timestamps
    end
  end
end
