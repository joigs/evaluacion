class Oxy < ApplicationRecord


  has_many :oxy_records, dependent: :destroy

  attr_accessor :conductores_eliminados

  validates :month, :year, :suma, :numero_conductores,
            :conductores_eliminados, presence: true

  validates :month,
            numericality: { only_integer: true, greater_than: 0,  less_than_or_equal_to: 12 }
  validates :year,
            numericality: { only_integer: true, greater_than_or_equal_to: 2000 }
  validates :suma,
            numericality: { greater_than_or_equal_to: 0 }
  validates :numero_conductores,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :conductores_eliminados,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
