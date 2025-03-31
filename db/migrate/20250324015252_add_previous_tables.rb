class AddPreviousTables < ActiveRecord::Migration[7.1]
  def change
    create_table :facturacions do |t|
      t.integer :number
      t.string :name
      t.date :solicitud
      t.date :emicion
      t.date :entregado
      t.integer :resultado, default: 0
      t.date :oc
      t.date :factura
      t.date :fecha_inspeccion
      t.float :precio

      t.timestamps
    end

    create_table :notifications do |t|
      t.string :title, null: false
      t.text :text, null: false
      t.integer :notification_type, null: false

      t.timestamps
    end

    create_table :notifications_facturacions do |t|
      t.bigint :notification_id, null: false
      t.bigint :facturacion_id, null: false

      t.timestamps
    end
    add_index :notifications_facturacions, [:notification_id, :facturacion_id], unique: true, name: 'index_notifications_facturacions_on_notification_and_facturacion'

    create_table :observacions do |t|
      t.text :texto
      t.bigint :facturacion_id, null: false
      t.bigint :user_id
      t.integer :momento

      t.timestamps
    end

    create_table :permisos do |t|
      t.string :nombre
      t.text :descripcion

      t.timestamps
    end

    create_table :user_permisos do |t|
      t.bigint :user_id, null: false
      t.bigint :permiso_id, null: false

      t.timestamps
    end

    create_table :users do |t|
      t.string :username, null: false
      t.string :password_digest, null: false
      t.boolean :admin, default: false
      t.string :real_name, default: "", null: false
      t.string :email
      t.string :profesion
      t.boolean :tabla, default: true
      t.string :empresa
      t.boolean :gestion, default: false, null: false
      t.boolean :super, default: false, null: false
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :users, :username, unique: true
    add_index :users, :deleted_at
  end
end
