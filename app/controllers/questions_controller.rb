class QuestionsController < ApplicationController

  def method_name
    
  end

  def show
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    @user = @question.user
    if @question.save
      redirect_to @user
    else
      @errors = @question.errors.full_messages
      render '@user'
    end 
  end

  def destroy
    @user = current_user
    @question = Question.find(params[:id])
    @question.destroy
    redirect_to edit_user_path(@user)
  end 



  private 
    def question_params
      params.require(:question).permit(:title, :text, :integer, :boolean, :user_id)
    end
      
end
