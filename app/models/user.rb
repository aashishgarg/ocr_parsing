class User < ApplicationRecord
  include Attachable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :validatable


  validates :email, uniqueness: true, presence: true, allow_blank: false#, format: { with: /\A[a-zA-Z0-9]+\z/ }

  has_many :bol_files

  def generate_jwt
    JWT.encode(
        {
          id: id,
          exp: 60.days.from_now.to_i
        },
        ENV['DEVISE_JWT_SECRET_KEY']
    )
  end
end
