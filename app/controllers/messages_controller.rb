class MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  include TimezoneHelper
  include TwilioHelper

  def reply
    message_body = params["Body"]
    @from_number = params["From"]
    user = User.find_by(phone_number: @from_number[2..-1])
    questions = user.questions

    if message_body.downcase == 'habits'
      boot_twilio

      if questions_today.empty?
        sms = @client.messages.create(
        from: ENV['TWILIO_NUMBER'],
        to: @from_number,
        body: "You've answered all your daily questions, nice job!" 
        )
      else
      sms = @client.messages.create(
        from: ENV['TWILIO_NUMBER'],
        to: @from_number,
        body: "Hey #{user.first_name}! Here's your questions for today: \n" + questions_today + 
 
"\nPlease answer with the question's number and parenthesis as the first two characters. Ex: '1) ...'"
        )
      end

    elsif message_body[0..3].include? ")"
      boot_twilio
      split_message = message_body.split(")")
      split_message[1] = split_message[1][1..-1]
      question = Question.find(split_message[0].to_i)
        if !split_message[1][0..4].include? ','  

          single_answer_helper

        elsif split_message[1][0..3].include? ',' 
          if !split_message[1][4..6].include? ',' 
            double_answer_helper
          else
            triple_answer_helper
          end
        end
        sms = @client.messages.create(
          from: ENV['TWILIO_NUMBER'],
          to: @from_number,
          body: "Your entry has been logged! " + responder
        )

    else    
      boot_twilio
      sms = @client.messages.create(
          from: ENV['TWILIO_NUMBER'],
          to: @from_number,
          body: "Incorrect keyword, try these:
- 'Habits' to bring up your remaining questions to answer today
- 'question #)' followed by your answer types to log and complete the question for today"
# - 'Show answers' to see the questions you've answered today
          )
    end  
  end

  private

  def boot_twilio
    @client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_AUTH_TOKEN']
  end
end
