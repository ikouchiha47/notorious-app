class ApplicationForm
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Serialization

  def int?(string)
    return true if string.is_a? Numeric

    string.scan(/\D/).empty?
  end

  def validates_associated(*forms)
    forms.each(&:valid?)
  end

  # TODO: we will come back to this later
  def self.validates_associated(*forms)
    forms.each do |form|
      obj = send(form.to_s)
      obj.valid?
    end
  end
end
