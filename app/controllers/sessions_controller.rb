class SessionsController < ApplicationController
  # skip_before_action :verify_authenticity_token

  def new
    @disable_nav = true
  end

  def create
    @user = User.find_by(email: params[:email])
    p @user
    if @user && @user.authenticate(params[:password])
      login(@user)
      respond_to do |format|
        format.html { redirect_to user_questions_path(@user) }
        format.json { render json: @user }
        # format.json { render json: { id: @user.id } }
      end
      
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