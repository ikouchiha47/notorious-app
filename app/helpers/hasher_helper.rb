module HasherHelper
  def self.digest(value)
    Digest::SHA2.hexdigest(value)
  end
end
