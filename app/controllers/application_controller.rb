class ApplicationController < ActionController::Base
  include ApplicationHelper

  before_action :set_breadcrumbs

  # before_action :print_seesion_tokens

  rescue_from Unauthorized, with: :handle_application_error
  rescue_from Unprocessible, with: :handle_application_error
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from StandardError, with: :handle_application_error # need to change this

  helper_method :breadcrumbs, :cart_items_count

  def index; end

  def add_breadcrumb(title, url, skip = false)
    @breadcrumbs[title] = { title:, url:, skip: }
  end

  def breadcrumbs
    @breadcrumbs.values
  end

  def not_found_method
    render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
  end

  def cart_items_count
    return 0 unless session[:cart_token].present?

    current_cart.count(1)
  end

  def print_seesion_tokens
    p 'cart token'
    p session[:cart_token]
    p 'access token'
    p session[:access_token]
  end

  private

  def set_cart_error_and_success_vars
    @cart_error_msgs = []
    @cart_success_msgs = []
  end

  def set_breadcrumbs
    @breadcrumbs = ActiveSupport::OrderedHash.new
  end

  def not_found
    # raise ActionController::RoutingError.new('Not Found')
    flash[:error] = 'The thing you are looking for no longer exists'
    redirect_back fallback_location: root_path
  end

  def handle_application_error(err)
    p err
    flash[:error] = err.message
    purge_tokens

    # redirect_to root_path
  end

  def purge_tokens
    session.delete(:cart_token)
    session.delete(:access_token)
    session.delete(:refresh_token)
  end
end
