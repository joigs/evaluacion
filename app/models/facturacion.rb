class Facturacion < ApplicationRecord
  has_many :observacions, dependent: :destroy
  has_many :notifications_facturacions, dependent: :destroy
  has_many :notifications, through: :notifications_facturacions

  has_one_attached :solicitud_file
  has_one_attached :cotizacion_doc_file
  has_one_attached :cotizacion_pdf_file
  has_one_attached :orden_compra_file
  has_one_attached :facturacion_file

  enum resultado: { "N/A": 0, "En espera": 1, "Aceptado": 2, "Rechazado": 3, "Relleno": 4 }

  validates :number, presence: true
  validates :name, presence: true




  after_initialize do
    self.solicitud ||= Date.today
  end


  validate :valid_file_types


  STEPS = [
    "Solicitud",
    "Emisión de Cotización",
    "Entrega a Cliente",
    "Orden de Compra",
    "Fecha Evaluación",
    "Factura"
  ].freeze

  def current_step_name
    STEPS[paso_actual || 0]
  end

  private

  def valid_file_types
    validate_file_type(solicitud_file, %w[application/vnd.ms-excel application/vnd.openxmlformats-officedocument.spreadsheetml.sheet], "Excel")
    validate_file_type(cotizacion_doc_file, %w[application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document], "Word")
    validate_file_type(cotizacion_pdf_file, %w[application/pdf], "PDF")
    validate_file_type(orden_compra_file, %w[application/pdf image/png image/jpeg image/jpg], "PDF, PNG, JPG, o JPEG")
    validate_file_type(facturacion_file, %w[application/pdf], "PDF")
  end

  def validate_file_type(file, allowed_types, type_name)
    if file.attached? && !file.content_type.in?(allowed_types)
      errors.add(file.name.to_sym, "debe ser un archivo #{type_name}")
    end
  end



end
