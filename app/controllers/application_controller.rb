class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  class AccessDenied < StandardError; end

    rescue_from AccessDenied, with: :record_not_found

  private

    def record_not_found
      render file: '/public/404.html', status: 404
    end

end

def current_user
  User.find_by(id: session[:user_id])
end
