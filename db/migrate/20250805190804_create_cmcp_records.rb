class CreateCmcpRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :cmcp_records do |t|
      t.date :fecha
      t.decimal :suma, precision: 10, scale: 2
      t.integer :numero
      t.references :cmcp, null: false, foreign_key: true

      t.timestamps
    end
  end
end
