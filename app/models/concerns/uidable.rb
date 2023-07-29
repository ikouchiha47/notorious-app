require 'ulid'

module Uidable
  extend ActiveSupport::Concern

  included do
    before_validation :set_ulid, on: :create
  end

  def set_ulid
    self.id = ULID.generate.to_s
  end
end
