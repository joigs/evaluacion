class AddV1ToOtros < ActiveRecord::Migration[7.1]
  def change
    add_column :otros, :v1, :decimal, precision: 8, scale: 4, default: 0.10, null: false
  end
end
