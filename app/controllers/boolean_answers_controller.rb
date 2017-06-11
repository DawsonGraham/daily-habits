class BooleanAnswersController < ApplicationController

  def show
    @boolean_answers = TextAnswer.all 
  end

  def new
    @boolean_answer = TextAnswer.new
  end

  def create
    @boolean_answer = TextAnswer.new(boolean_answer_params)
    if @boolean_answer.save
      redirect_to root_path
    else
      @errors = @boolean_answer.errors.full_messages
      render 'new'
    end 
  end


  private
    def boolean_answer_params
      params.require(:boolean_answer).permit(:response, :question_id)
    end
end
