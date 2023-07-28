class ApplicationController < ActionController::Base
  before_action :set_breadcrumbs
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
    p "record not found raise manually"
    raise ActionController::RoutingError.new('Not Found')
  end

end
