class Role < ApplicationRecord
  # Constants
  ALL = %i(admin customer support)

  # Modules Inclusions
  scopify

  # Associations
  has_and_belongs_to_many :users, :join_table => :users_roles
  belongs_to :resource, :polymorphic => true, :optional => true

  # Validations
  validates :resource_type, :inclusion => {:in => Rolify.resource_types}, :allow_nil => true
  validates :name, presence: true, inclusion: {in: ALL, message: "is not included in the list #{ALL}"}
end
