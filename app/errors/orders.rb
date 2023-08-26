module OrderErrors
  class ValidationFailed < StandardError
    def message
      <<-HEREDOC
      Failed to validate requirements for placing order.
      HEREDOC
    end
  end
end
