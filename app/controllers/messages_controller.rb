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

    elsif message_body.downcase == "weather"
      boot_twilio
      sms = @client.messages.create(
          from: ENV['TWILIO_NUMBER'],
          to: @from_number,
          body: "Please provide a city name after 'Weather'."
        )

    elsif message_body[0..6].downcase == "weather"
      boot_twilio
      key = ENV['WEATHER_KEY']
      split = message_body.split(" ", 2)
      city = split[1]
      city = city.split.map(&:capitalize).join('_')

      response = HTTParty.get("http://api.wunderground.com/api/#{key}/geolookup/conditions/q/#{params["FromState"]}/#{city}.json")
    
      if response.parsed_response["response"]["error"] != nil
        sms = @client.messages.create(
          from: ENV['TWILIO_NUMBER'],
          to: @from_number,
          body: "Sorry, no cities matched your search. Please check the spelling and try again!."
        )
      
      else
        if city.include? "_"
          city = city.split("_").join(" ")
        end

        weather = response['current_observation']['weather']
        temp = response['current_observation']['temp_f']
        wind = response['current_observation']['wind_mph']

        sms = @client.messages.create(
            from: ENV['TWILIO_NUMBER'],
            to: @from_number,
            body: "The weather is #{weather} in #{city}. The temp is #{temp}℉ with #{wind}mph winds."
          )
      end

    else    
      boot_twilio
      sms = @client.messages.create(
          from: ENV['TWILIO_NUMBER'],
          to: @from_number,
          body: "Incorrect keyword, try these:
- 'Habits' to bring up your remaining questions to answer today
- 'Question #)' followed by your answer types to log and complete the question for today
- 'Weather (city name)' to get information about the weather conditions today"
          )
    end  
  end

  private

  def boot_twilio
    @client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_AUTH_TOKEN']
  end

  def city_converter

  end
end
