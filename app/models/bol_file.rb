class BolFile < ApplicationRecord
  belongs_to :user, foreign_key: :status_updated_by
  belongs_to :shipper
  belongs_to :bol_type
end
