class AddForeignKeys < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :notifications_facturacions, :notifications
    add_foreign_key :notifications_facturacions, :facturacions

    add_foreign_key :observacions, :facturacions
    add_foreign_key :observacions, :users

    add_foreign_key :user_permisos, :users
    add_foreign_key :user_permisos, :permisos
  end
end
