class SessionsController < ApplicationController
  after_filter "remember_url", only: [:new]

  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:email])

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to projects_path
    else
      flash[:alert] = "Invalid Email and/or Password"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/'
  end

  def remember_url
    if request.referer.present?
      session[:remember_url] = URI(request.referer).path
    else
      session[:remember_url] = new_project_path
    end
  end

end
