class UsersController < ApplicationController

  def index
    @disable_nav = true
  end

  def new
    @disable_nav = true
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login(@user)
      redirect_to @user, notice: "Sign up successful dick"
    else
      @errors = @user.errors.full_messages
      render 'new'
    end 
  end

  def edit
    @user = User.find(params[:id])
    @questions = Question.where(user_id: @user.id)
  end

  def show
    @user = User.find(params[:id])
    @questions = Question.where(user_id: @user.id)
  end 

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :avatar, :password)
    end

end
