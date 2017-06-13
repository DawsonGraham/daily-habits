class BooleanAnswersController < ApplicationController

  def show
    @boolean_answers = BooleanAnswer.all 
  end

  def new
    @boolean_answer = BooleanAnswer.new
  end

  def create
    @user = current_user
    @question = Question.find(params[:question_id])
    @boolean_answer = BooleanAnswer.new(boolean_answer_params)
    @boolean_answer.question_id = @question.id
      if @boolean_answer.save
        redirect_to @user
      else
        @errors = @boolean_answer.errors.full_messages
        redirect_to @user
      end 
  end


  private
    def boolean_answer_params
      params.require(:boolean_answer).permit(:response, :question_id)
    end
end
