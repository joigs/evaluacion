class RenameCmcpToCmpc < ActiveRecord::Migration[7.1]
  def change
    rename_table :cmcps, :cmpcs

    rename_table :cmcp_records, :cmpc_records

    rename_column :cmpc_records, :cmcp_id, :cmpc_id
  end
end
