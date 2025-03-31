class Observacion < ApplicationRecord
  belongs_to :facturacion
  belongs_to :user, optional: true

  enum momento: {
    "Solicitud de cotización" => 0,
    "Emisión de cotización" => 1,
    "Entregado a cliente" => 2,
    "Orden de compra" => 3,
    "Definición fecha de evaluación" => 4,
    "Emisión de factura" => 5
  }
  validates :texto, presence: true
end
