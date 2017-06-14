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
    # NEED TO REPLACE FAKE_IP WITH request.remote_ip
    @boolean_answer.ip_address = fake_ip
      if @boolean_answer.save
        redirect_to user_questions_path(@user)
      else
        @errors = @boolean_answer.errors.full_messages
        redirect_to user_questions_path(@user)
      end 
  end


  private
    def boolean_answer_params
      params.require(:boolean_answer).permit(:response, :question_id, :ip_address)
    end

    def random_num
      rand(1..9)
    end

    def fake_ip
      "192.206.151.131"
    end
end
