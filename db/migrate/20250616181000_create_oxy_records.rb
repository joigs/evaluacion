class CreateOxyRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :oxy_records do |t|
      t.date :fecha
      t.references :oxy, null: false, foreign_key: true

      t.timestamps
    end
  end
end
