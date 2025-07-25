class RemoveEmpresaFromAlds < ActiveRecord::Migration[7.1]
  def change
    remove_index :alds, [:empresa_id, :year, :month], if_exists: true

    remove_reference :alds, :empresa, foreign_key: true, index: true
  end
end
