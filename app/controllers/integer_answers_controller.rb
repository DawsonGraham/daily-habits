class IntegerAnswersController < ApplicationController

  def show
    @integer_answers = IntegerAnswer.all 
  end

  def new
    @integer_answer = IntegerAnswer.new
  end

  def create
    @user = current_user
    @question = Question.find(params[:question_id])
    @integer_answer = IntegerAnswer.new(integer_answer_params)
    @integer_answer.question_id = @question.id
    if @integer_answer.save
      redirect_to user_questions_path(@user)
    else
      @errors = @integer_answer.errors.full_messages
      redirect_to user_questions_path(@user)
    end 
  end


  private
    def integer_answer_params
      params.require(:integer_answer).permit(:response, :question_id)
    end

end
