class Token < ApplicationRecord
  validates :access_token, presence: true
end
