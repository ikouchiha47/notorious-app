class ApplicationController < ActionController::Base
  def index
  
  end

  private

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

end
