class BolType < ApplicationRecord
  has_many :bol_files

  validates :name, uniqueness: true, presence: true, allow_blank: false # Add scope if shipper_id is needed
  # belongs_to :shipper
end
