class ChangeTotalScaleOnAlds < ActiveRecord::Migration[7.1]
  def change
    change_column :alds, :total, :decimal, precision: 12, scale: 2
    change_column :otros, :total, :decimal, precision: 12, scale: 2

  end
end
