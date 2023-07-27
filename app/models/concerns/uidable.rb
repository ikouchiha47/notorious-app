require 'ulid'

module Uidable
  extend ActiveSupport::Concern

  included do
    before_create :set_ulid
  end

  def set_ulid
    self.id = ULID.generate.to_s
  end
end
