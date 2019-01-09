class User < ApplicationRecord
  rolify
  include Attachable

  devise :database_authenticatable, :registerable, :recoverable, :validatable

  validates :email, uniqueness: true, presence: true, allow_blank: false#, format: { with: /\A[a-zA-Z0-9]+\z/ }

  has_many :bol_files

  # Callbacks
  after_create :assign_default_role

  # Get current user
  def self.current
    Thread.current[:user]
  end

  # Set current user
  def self.current=(user)
    Thread.current[:user] = user
  end

  def generate_jwt
    JWT.encode(
        {
          id: id,
          exp: 60.days.from_now.to_i
        },
        ENV['DEVISE_JWT_SECRET_KEY']
    )
  end

  private

  def assign_default_role

  end
end
