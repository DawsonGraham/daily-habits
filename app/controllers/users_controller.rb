class UsersController < ApplicationController

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
      respond_to do |format|
        format.html { redirect_to @user, notice: "Sign up successful dick" }
        format.json { render json: @user }
      end
    else
      @errors = @user.errors.full_messages
      respond_to do |format|
        format.html { render 'new' }
        format.json { render json: @errors }
      end
    end 
  end

  def edit
    @user = User.find(params[:id])
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
      # format.json { render json: @user.as_json(include: {questions: {include: \\
      format.json { render json: @user }
      # render json: tests.as_json(:include => {:questions => {:include => :subject}, :bonuses => {:include => :subject}})

    end

  end 

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :avatar, :password)
    end

end
