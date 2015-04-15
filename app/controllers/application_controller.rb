class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  before_action :authenticate

  class AccessDenied < StandardError; end

    rescue_from AccessDenied, with: :record_not_found

  def current_user
    User.find_by(id: session[:user_id])
  end


  private

    def record_not_found
      render file: '/public/404.html', status: 404
    end

    def authenticate
      unless current_user
        session[:return_path] = request.env['PATH_INFO']
      end
      redirect_to signin_path, :alert => 'You must be logged in to visit that page.' unless current_user
    end

end
