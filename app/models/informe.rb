require "bigdecimal"
require "bigdecimal/util"

class Informe < ApplicationRecord
  before_validation :set_month_and_year, if: -> { fecha.present? }
  before_validation :calcular_total

  validates :mandante_rut,    presence: true
  validates :mandante_nombre, presence: true
  validates :fecha,           presence: true
  validates :n_informes,     numericality: { only_integer: true, greater_than: 0 }
  validates :valor_unitario, numericality: { greater_than_or_equal_to: 0 }
  validates :total,          numericality: { greater_than_or_equal_to: 0 }

  private

  def calcular_total
    n   = BigDecimal(n_informes.to_s.presence || "0")
    val = BigDecimal(valor_unitario.to_s.presence || "0")

    self.total = (n * val).round(2, BigDecimal::ROUND_HALF_UP)
  rescue ArgumentError
    self.total = 0
  end

  def set_month_and_year
    self.month = fecha.month
    self.year  = fecha.year
  end
end