require 'twilio-ruby'

class UsersController < ApplicationController
  include SessionsHelper

  def index
    @disable_nav = true
    # request.remote_ip
  end

  def new
      @disable_nav = true
      @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login(@user)
      # send intro text here
      @client = Twilio::REST::Client.new(ENV['TWILIO_SID'], ENV['TWILIO_AUTH_TOKEN'])
      @message = @client.messages.create(
        from: ENV['TWILIO_NUMBER'],
        body: "Hi #{@user.first_name}! Thanks for registering with Habits. After creating your daily questions online, text 'Habits' to this number to see and answer your questions.",
        to: "+1#{@user.phone_number}")
      
      # respond_to do |format|
      #   format.html { redirect_to @user, notice: "Signup Successful!" }
      #   format.json { render json: @user }
      # end
    else
      @errors = @user.errors.full_messages
    end 
  end

  def edit
    @user = current_user
    @questions = Question.where(user_id: @user.id)
  end

  def show
    @user = User.find(params[:id])
    @questions = @user.questions

    gon.questions = @questions
    gon.answers = []

    @user.integer_answers.last_seven_days.each do |int|
      gon.answers << int
    end
    @user.text_answers.last_seven_days.each do |txt|
      gon.answers << txt 
    end
    @user.boolean_answers.last_seven_days.each do |bool|
      gon.answers << bool 
    end
    
    respond_to do |format|
      format.html { }
      format.json { render json: @user }
    end

  end 

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :avatar, :password)
    end

end
