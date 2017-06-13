class MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  include TimezoneHelper

# THE CODE BELOW WILL BE REFACTORED TO BE MORE DRY. ALL TEXT COMMANDS CURRENTLY WORKING BESIDES 'Show answers'

  def reply
    message_body = params["Body"]
    @from_number = params["From"]
    # questions = Question.all
    user = User.find_by(phone_number: @from_number[1..-1])
    questions = user.questions

    if message_body.downcase == 'habits'
      boot_twilio

      if questions_today.empty?
        sms = @client.messages.create(
        from: ENV['TWILIO_NUMBER'],
        to: @from_number,
        body: "You've answered all your daily questions, nice job!" 
        # Text 'Show answers' to see your answers for today
        )
      else
      sms = @client.messages.create(
        from: ENV['TWILIO_NUMBER'],
        to: @from_number,
        body: "Here are your questions for today: \n" + questions_today + 
 
"\nPlease answer with the question's number and parenthesis as the first two characters. Ex: '1) ...'"
        )
      end

    elsif message_body[0..3].include? ")"
      boot_twilio
      split_message = message_body.split(")")
      split_message[1] = split_message[1][1..-1]

      
      question = Question.find(split_message[0].to_i)
        if !split_message[1][0..4].include? ','
          
          if split_message[1].downcase == "yes" || split_message[1].downcase == "ya" || split_message[1].downcase == "y" || split_message[1].downcase == "n" || split_message[1].downcase == "no"
             if split_message[1].downcase == "yes" || split_message[1].downcase == "ya" || split_message[1].downcase == "y"
               question.boolean_answers.create(response: true) 
             elsif split_message[1].downcase == "n"
               question.boolean_answers.create(response: false)
             end
          
          elsif split_message[1].to_i > 0
            question.integer_answers.create(response: split_message[1].to_i)

          else
            question.text_answers.create(response: split_message[1])
          end

        elsif split_message[1][0..3].include? ',' 
          if !split_message[1][4..6].include? ','
            double_split = split_message[1].split(',', 2)
            double_split[1] = double_split[1][1..-1]

            # double_split will = [5, some random text] or [y, 5] or [5, random text here]
            if double_split[0].downcase == "y" || double_split[0].downcase == "yes" || double_split[0].downcase == "n" || double_split[0].downcase == "no" && double_split[1].to_i > 0
              if double_split[0].downcase == "yes" || double_split[0].downcase == "ya" || double_split[0].downcase == "y"
                question.boolean_answers.create(response: true)
              elsif double_split[0].downcase == "n"
                question.boolean_answers.create(response: false)
              end
              question.integer_answers.create(response: double_split[1])

            elsif double_split[0].downcase == "y" || double_split[0].downcase == "n" && double_split[1].to_i == 0
              if double_split[0].downcase == "yes" || double_split[0].downcase == "ya" || double_split[0].downcase == "y"
                question.boolean_answers.create(response: true)
              elsif double_split[0].downcase == "n"
                question.boolean_answers.create(response: false)
              end
              question.text_answers.create(response: double_split[1])

            elsif double_split[0].to_i > 0 
              question.integer_answers.create(response: double_split[0].to_i)
              question.text_answers.create(response: double_split[1])
            end
          else
            double_split = split_message[1].split(',', 2)
            double_split[1] = double_split[1][1..-1]
            triple_split = double_split[1].split(',', 2)
            triple_split.unshift(double_split[0])
            triple_split[2] = triple_split[2][1..-1]

            if triple_split[0].downcase == 'y' || triple_split[0].downcase == 'yes' || triple_split[0].downcase == 'ya'
              question.boolean_answers.create(response: true)
            elsif triple_split[0].downcase == 'n'
              question.boolean_answers.create(response: false)
            end
            question.integer_answers.create(response: triple_split[1])
            question.text_answers.create(response: triple_split[2])
          end
        end
        sms = @client.messages.create(
          from: ENV['TWILIO_NUMBER'],
          to: @from_number,
          body: "Your entry has been logged! Here are your remaining questions for today: \n" + questions_today
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

  def questions_today
    user = User.find_by(phone_number: @from_number[1..-1])
    questions = user.questions
    # questions = Question.all
    show = []
    questions.each do |question|
      if question.integer == true && question.boolean == false && question.text == false
        int_check = []
        question.integer_answers.each do |int_answer|
          int_check << int_answer.created_at.strftime('%Y%m%d') 
        end
        if !int_check.include? time_converter.strftime('%Y%m%d')
          show.push("\n #{question.id}) #{question.title} (Rating)") 
        end
      elsif question.integer == false && question.boolean == true && question.text == false
        bool_check = []
        question.boolean_answers.each do |bool_answer|
          bool_check << bool_answer.created_at.strftime('%Y%m%d')
        end
        if !bool_check.include? time_converter.strftime('%Y%m%d')
          show.push("\n #{question.id}) #{question.title} (Y/N) \n")
        end
      elsif question.integer == false && question.boolean == false && question.text == true
        text_check = []
        question.text_answers.each do |text_answer|
          text_check << text_answer.created_at.strftime('%Y%m%d')
        end
        if !text_check.include? time_converter.strftime('%Y%m%d')
          show.push("\n #{question.id}) #{question.title} (Text) \n")
        end
      elsif question.integer == true && question.boolean == true && question.text == false
        int_bool_check = []
        question.integer_answers.each do |int_answer|
          int_bool_check << int_answer.created_at.strftime('%Y%m%d') 
        end
        question.boolean_answers.each do |bool_answer|
          int_bool_check << bool_answer.created_at.strftime('%Y%m%d')
        end
        if !int_bool_check.include? time_converter.strftime('%Y%m%d')
          show.push("\n #{question.id}) #{question.title} (Y/N, Rating) \n")
        end
      elsif question.integer == false && question.boolean == true && question.text == true
        bool_text_check = []
        question.boolean_answers.each do |bool_answer|
          bool_text_check << bool_answer.created_at.strftime('%Y%m%d') 
        end
        question.text_answers.each do |text_answer|
          bool_text_check << text_answer.created_at.strftime('%Y%m%d')
        end
        if !bool_text_check.include? time_converter.strftime('%Y%m%d')
          show.push("\n #{question.id}) #{question.title} (Y/N, Text) \n")
        end
      elsif question.integer == true && question.boolean == false && question.text == true
        int_text_check = []
        question.integer_answers.each do |int_answer|
          int_text_check << int_answer.created_at.strftime('%Y%m%d') 
        end
        question.text_answers.each do |text_answer|
          int_text_check << text_answer.created_at.strftime('%Y%m%d')
        end
        if !int_text_check.include? time_converter.strftime('%Y%m%d')
          show.push("\n #{question.id}) #{question.title} (Rating, Text) \n")
        end
      elsif question.integer == true && question.boolean == true && question.text == true
        int_text_bool_check = []
        question.integer_answers.each do |int_answer|
          int_text_bool_check << int_answer.created_at.strftime('%Y%m%d') 
        end
        question.text_answers.each do |text_answer|
          int_text_bool_check << text_answer.created_at.strftime('%Y%m%d')
        end
        question.boolean_answers.each do |bool_answer|
          int_text_bool_check << bool_answer.created_at.strftime('%Y%m%d')
        end
        if !int_text_bool_check.include? time_converter.strftime('%Y%m%d')
          show.push("\n #{question.id}) #{question.title} (Y/N, Rating, Text) \n")
        end
      end
    end
    show.join(' ')
  end

  def boot_twilio
    @client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_AUTH_TOKEN']
  end
end
