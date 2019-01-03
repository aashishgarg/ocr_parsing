class BolType < ApplicationRecord
  has_many :bol_files

  belongs_to :shipper
end
