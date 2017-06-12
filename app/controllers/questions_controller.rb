class QuestionsController < ApplicationController

  def show
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      redirect_to question_path
    else
      @errors = @question.errors.full_messages
      render 'new'
    end 
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy!
    redirect_to question_path
  end 



  private 
    def def question_params
      params.require(:question).permit(:title, :text, :integer, :boolean, :user_id)
    end
      
end
