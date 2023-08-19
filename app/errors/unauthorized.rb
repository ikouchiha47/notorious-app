class Unauthorized < StandardError
  include ActiveModel::Serialization

  attr_accessor :status, :code, :message

  def message
    @message || 'Sorry, you do not have enough permission for this. Please logout and/or login'
  end

  def status
    :unauthorized
  end
end
