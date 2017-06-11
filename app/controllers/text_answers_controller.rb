class TextAnswersController < ApplicationController

  def show
    @text_answers = TextAnswer.all 
  end

  def new
    @text_answer = TextAnswer.new
  end

  def create
    @text_answer = TextAnswer.new(text_answer_params)
    if @text_answer.save
      redirect_to root_path
    else
      @errors = @text_answer.errors.full_messages
      render 'new'
    end 
  end


  private
    def text_answer_params
      params.require(:text_answer).permit(:response, :question_id)
    end
end
