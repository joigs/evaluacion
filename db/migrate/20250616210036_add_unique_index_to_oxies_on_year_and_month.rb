class AddUniqueIndexToOxiesOnYearAndMonth < ActiveRecord::Migration[7.1]
  def change
    add_index :oxies, [:year, :month], unique: true
  end
end
