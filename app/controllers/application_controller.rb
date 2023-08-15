class ApplicationController < ActionController::Base
  include ApplicationHelper

  before_action :set_breadcrumbs

  rescue_from Unauthorized, with: :handle_application_error
  rescue_from Unprocessible, with: :handle_application_error
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  helper_method :breadcrumbs

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

  private

  def set_breadcrumbs
    @breadcrumbs = ActiveSupport::OrderedHash.new
  end

  def not_found
    # raise ActionController::RoutingError.new('Not Found')
    flash[:error] = 'Item sold out'
    redirect_back(fallback_location: root_path) and return
  end

  def current_user
    return User.new(user_id: nil) unless current_token.present? && current_token.valid?

    @current_user ||= User.find_by!(user_id: current_token.resource_id)
    session[:access_token] = current_token.session_token
  end

  def current_token
    return nil unless session[:access_token].present? && session[:refresh_token].present?

    @current_token ||= Token.find_by_token(session[:access_token], session[:refresh_token])
  end

  def handle_application_error(e)
    flash[:error] = e.message
    redirect_back(fallback_location: root_path)
  end
end
