class SessionsController < ApplicationController

  def new
    @disable_nav = true
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user && @user.authenticate(params[:password])
      login(@user)
      redirect_to users_questions_path(@user)
    else
      @disable_nav = true
      @errors = ["Incorrect email or password"]
      render 'new'
    end 
  end

  def destroy
    logout
    redirect_to root_path
  end

end
