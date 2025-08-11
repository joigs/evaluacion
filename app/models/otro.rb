require "bigdecimal"
require "bigdecimal/util"

class Otro < ApplicationRecord
  belongs_to :empresa

  attr_accessor :t_pesos
  before_validation :set_month_and_year if :fecha_changed?

  before_validation :calcular_total

  validates :v1, numericality: { greater_than_or_equal_to: 0 }
  validates :n1, numericality: { greater_than_or_equal_to: 0 }
  validates :total, numericality: { greater_than_or_equal_to: 0 }

  private

  def calcular_total
    iva = Iva.find_by(year: year, month: month)
    unless iva
      errors.add(:base, "No existe UF para #{month}-#{year}")
      return
    end

    n1_big      = BigDecimal(n1.to_s,       12)
    t_pesos_big = BigDecimal(t_pesos.to_s,  12)
    uf_big      = BigDecimal(iva.valor.to_s,12)
    v1_big      = BigDecimal(v1.to_s,      12)

    t_uf = t_pesos_big / uf_big

    total_big = (v1_big * n1_big) + t_uf

    self.total = total_big.round(2, BigDecimal::ROUND_HALF_UP)
  end


  def set_month_and_year
    return unless fecha.present?

    self.month = fecha.month
    self.year  = fecha.year
  end

end
