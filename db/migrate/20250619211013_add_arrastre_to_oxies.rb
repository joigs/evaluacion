class AddArrastreToOxies < ActiveRecord::Migration[7.1]
  def change
    add_column :oxies, :arrastre, :integer
  end
end
