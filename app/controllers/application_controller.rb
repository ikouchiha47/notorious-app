class ApplicationController < ActionController::Base
  before_action :set_breadcrumbs

  rescue_from Unauthorized, with: :handle_application_error
  rescue_from Unprocessible, with: :handle_application_error
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  helper_method :breadcrumbs

  def index
  end

  def add_breadcrumb(title, url)
    @breadcrumbs[title] = { title:, url: }
  end

  def breadcrumbs
    @breadcrumbs.values
  end

  private

  def set_breadcrumbs
    @breadcrumbs = ActiveSupport::OrderedHash.new
  end


  def not_found
    # raise ActionController::RoutingError.new('Not Found')
    flash[:error] = 'something went wrong'
    redirect_back(fallback_location: root_path)

  end

  def current_user
    return User.new(user_id: nil) unless session[:current_user].present?

    token = Token.find_user_token!(session[:current_user])
    @current_user ||= User.find_by!(user_id: token.resource_id)
  end

  def handle_application_error(e)
    flash[:error] = e.message
    redirect_back(fallback_location: root_path)
  end
end
