class TextAnswersController < ApplicationController

  def show
    @user = current_user
    @question = Question.find(params[:question_id])
    @text_answer = TextAnswer.find(params[:id])
  end

  def new
    @text_answer = TextAnswer.new
  end

  def create
    @user = current_user
    @question = Question.find(params[:question_id])
    @text_answer = TextAnswer.new(text_answer_params)
    @text_answer.question_id = @question.id
    if @text_answer.save
      redirect_to user_questions_path(@user)
    else
      @errors = @text_answer.errors.full_messages
      redirect_to user_questions_path(@user)
    end 
  end


  private
    def text_answer_params
      params.require(:text_answer).permit(:response, :question_id)
    end
end
