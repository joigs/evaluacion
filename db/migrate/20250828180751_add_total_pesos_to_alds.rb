class AddTotalPesosToAlds < ActiveRecord::Migration[7.1]
  def change
    add_column :alds, :total_pesos, :integer, null:true
  end
end
