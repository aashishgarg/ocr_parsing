class Shipper < ApplicationRecord
  has_many :bol_types

  belongs_to :user
  alias_attribute :contact, :user
  alias_attribute :contact_id, :user_id

  accepts_nested_attributes_for :user

  validates :name, uniqueness: true, presence: true, allow_blank: false
end
