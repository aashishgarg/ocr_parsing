class Shipper < ApplicationRecord
  # has_many :bol_types

  validates :name, uniqueness: true, presence: true, allow_blank: false
  validates_format_of :contact_email, with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
end
