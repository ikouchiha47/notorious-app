require 'ulid'

module ULiDAble
  extend ActiveSupport::Concern

  included do
    before_create :set_ulid
  end

  def set_ulid
    self.ulid = ULID.generate.to_s
  end
end
