class ApplicationController < ActionController::Base
  def index
  
  end

  private

  def not_found
    p "record not found raise manually"
    raise ActionController::RoutingError.new('Not Found')
  end

end
