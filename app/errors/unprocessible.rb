  class Unprocessible < StandardError
    include ActiveModel::Serialization

    attr_accessor :status, :code, :message

    def status
      :unprocessible
    end
  end
