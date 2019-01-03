class Shipper < ApplicationRecord
  has_many :bol_types

  belongs_to :user
end
