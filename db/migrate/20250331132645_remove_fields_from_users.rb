class RemoveFieldsFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :profesion, :string
    remove_column :users, :empresa, :string
    remove_column :users, :gestion, :boolean
  end
end
