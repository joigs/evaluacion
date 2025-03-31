class User < ApplicationRecord
  has_secure_password

  acts_as_paranoid

  def self.ransackable_attributes(auth_object = nil)
    [
      "username",
      "real_name",
      "email",
      "created_at",
      "updated_at"
    ]
  end



  validates :username, presence: true, uniqueness: true,
            length: { in: 3..15 },
            format: {with: /\A[a-z0-9A-Z]+\z/, message: "Solo se permiten letras y numeros"}
  validates :password_digest, length: { minimum: 6 }
  validates :real_name, presence: true
  validates :email, allow_blank: true,
            format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, message: "Formato de email invalido" }





  has_many :user_permisos, dependent: :destroy
  has_many :permisos, through: :user_permisos
  has_many :observacions, dependent: :nullify




  def solicitar
    permisos.exists?(nombre: 'solicitar')
  end

  def cotizar
    permisos.exists?(nombre: 'cotizar')
  end






end
