module Middleware
  class PathHandler
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)
      path_info = request.path_info

      # Remove '/shop/' prefix if present
      request.path_info = path_info.sub('/shop', '/') if path_info.start_with?('/shop')

      @app.call(env)
    end
  end
end
