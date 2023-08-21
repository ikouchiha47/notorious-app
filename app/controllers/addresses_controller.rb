class AddressesController < ApplicationController
  before_action :logged_in?

  def index
    @form = AddressFormBuilder.new
    @addresses = Address.vieweable(current_user.id)
  end

  def update
    @form = AddressFormBuilder.new(*address_params)
    unless @form.valid?
      return respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            'address-form',
            partial: 'addresses/form',
            locals: {
              form: @form,
              form_state: 'show'
            }
          )
        end

        format.html { redirect_back fallback_location: my_review_carts_url, status: 422 }
      end
    end

    address_model_params = {
      address_line_a: @form.address_line_a,
      address_line_b: @form.address_line_b,
      zip_code: @form.zip_code,
      alternate_number: @form.alternate_number,
      tag: @form.tag.capitalize
    }

    @address = if new_address?
                 current_user.addresses.create(address_model_params)
               else
                 current_address.update(address_model_params)
               end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: my_review_carts_url, status: 200 }
    end
  end

  def delete
    current_address.update(deleted_at: Time.now.utc)

    respond_to do |f|
      f.turbo_stream { render turbo_stream: turbo_stream.remove("#{helpers.dom_id(current_address)}_details") }
    end
  end

  private

  def new_address?
    !params[:id].present?
  end

  def current_address
    @current_address ||= Address.find_by(id: params[:id], user_id: current_user.id)
  end

  def address_params
    params.require(:address_form_builder).permit(*AddressFormBuilder.attributes)
  end
end
