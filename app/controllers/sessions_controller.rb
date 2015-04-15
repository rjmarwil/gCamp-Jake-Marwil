class SessionsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:email])

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "You have successfully signed in"
      if session[:return_path]
        redirect_to session[:return_path]
      else
        redirect_to projects_path
      end
    else
      flash[:alert] = "Invalid Email and/or Password"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/'
  end

end
