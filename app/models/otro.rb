require "bigdecimal"
require "bigdecimal/util"

class Otro < ApplicationRecord
  belongs_to :empresa

  V1 = BigDecimal("0.10")
  attr_accessor :t_pesos

  before_validation :calcular_total

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

    t_uf = t_pesos_big / uf_big

    total_big = (V1 * n1_big) + t_uf

    self.total = total_big.round(2, BigDecimal::ROUND_HALF_UP)
  end
end
