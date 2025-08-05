class Cmpc < ApplicationRecord


  has_many :cmpc_records, dependent: :destroy



  validates :month,
            numericality: { only_integer: true, greater_than: 0,  less_than_or_equal_to: 12 }
  validates :year,
            numericality: { only_integer: true, greater_than_or_equal_to: 2000 }
  validates :total_uf,
            numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  validates :numero_servicios,
            numericality: { only_integer: true, greater_than_or_equal_to: 0, allow_nil: true }

  def set_defaults
    self.numero_servicios ||= 0
    self.total_uf = 0 if self.total_uf.nil?
  end
end
