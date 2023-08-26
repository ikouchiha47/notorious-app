class HomeController < ApplicationController
  include SessionGenerator
  include MomentHelper

  def index
    @products = Product.featured
  end

  def peppermint_spray
    @session_id = generate_session_id(request)

    etag = session_id
    etag_from_client = request.headers['If-None-Match']

    last_modified = Time.at(0).utc
    last_modified_from_client = request.headers['If-Modified-Since']

    if last_modified_from_client.present?
      value = str_to_date(last_modified_from_client)

      if value <= 1.month.ago.utc
        head :not_modified
        return
      end
    end

    # rocketag. meaning, we don't check if it even matched
    # we are going hard core, 304
    if etag_from_client.present?
      head :not_modified
      return
    end

    response.set_header('ETag', etag)

    # Set other relevant caching headers
    response.set_header('Last-Modified', last_modified)
    response.set_header('Cache-Control', 'private, max-age=31536000, s-max-age=31536000, must-revalidate')

    # Render the dynamic JavaScript file
    respond_to do |format|
      format.js { render 'home/peppermint.js.erb', content_type: 'application/javascript' }
    end
  end
end
