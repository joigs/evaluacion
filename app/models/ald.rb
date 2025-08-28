require "bigdecimal"
require "bigdecimal/util"

class Ald < ApplicationRecord
  V1 = BigDecimal("0.1")
  V2 = BigDecimal("0.27")

  before_validation :calcular_total

  private

  def calcular_total
    iva = Iva.find_by(year: year, month: month)
    unless iva
      errors.add(:base, "No existe UF para #{month}-#{year}")
      return
    end

    n1_big      = BigDecimal(n1.to_s,       12)
    t_pesos_big = BigDecimal(total_pesos.to_s,  12)
    uf_big      = BigDecimal(iva.valor.to_s,12)
    n2_big       = BigDecimal(n2.to_s,       12)
    t_uf    = t_pesos_big / uf_big

    total_big = (V1 * n1_big) + (V2 * n2_big) + t_uf


    self.total = total_big.round(2, BigDecimal::ROUND_HALF_UP)
  end
end
