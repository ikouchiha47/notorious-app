  class Unauthorized < StandardError
    include ActiveModel::Serialization

    attr_accessor :status, :code, :message

    def status
      :unauthorized
    end
  end
