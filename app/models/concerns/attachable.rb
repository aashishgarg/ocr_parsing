module Attachable
  extend ActiveSupport::Concern

  included do
    has_many :attachments, as: :attachable, dependent: :destroy
    alias_attribute :data, :attachments
  end
end