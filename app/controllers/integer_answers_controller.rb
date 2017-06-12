class IntegerAnswersController < ApplicationController

  def show
    @integer_answers = TextAnswer.all 
  end

  def new
    @integer_answer = TextAnswer.new
  end

  def create
    @integer_answer = TextAnswer.new(integer_answer_params)
    if @integer_answer.save
      redirect_to root_path
    else
      @errors = @integer_answer.errors.full_messages
      render 'new'
    end 
  end


  private
    def integer_answer_params
      params.require(:integer_answer).permit(:response, :question_id)
    end

end
