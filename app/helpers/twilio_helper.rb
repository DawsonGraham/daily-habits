module TwilioHelper

  def responder
    @from_number = params["From"]
    user = User.find_by(phone_number: @from_number[2..-1])
    questions = user.questions
    if questions_today.empty?
      response = "You've answered all your daily questions, nice job!"
    else
      response = "Here are your remaining questions for today: \n" + questions_today
    end
    response
  end

  def questions_today
    user = User.find_by(phone_number: @from_number[2..-1])
    questions = user.questions
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

  def single_answer_helper
    geocode = Geocoder.coordinates("#{params["FromCity"]}, #{params["FromState"]}, #{params["FromZip"]}")
    message_body = params["Body"]
    @from_number = params["From"]
    user = User.find_by(phone_number: @from_number[2..-1])
    split_message = message_body.split(")")
    split_message[1] = split_message[1][1..-1]
    question = Question.find(split_message[0].to_i)

    if split_message[1].downcase == "yes" || split_message[1].downcase == "ya" || split_message[1].downcase == "y" || split_message[1].downcase == "n" || split_message[1].downcase == "no"
       split_message[1].downcase == "yes" || split_message[1].downcase == "ya" || split_message[1].downcase == "y" ? question.boolean_answers.create(response: true, latitude: geocode[0], longitude: geocode[1]) : question.boolean_answers.create(response: false, latitude: geocode[0], longitude: geocode[1])    
    elsif split_message[1].to_i > 0 
      question.integer_answers.create(response: split_message[1].to_i, latitude: geocode[0], longitude: geocode[1])
    else
      question.text_answers.create(response: split_message[1], latitude: geocode[0], longitude: geocode[1])
    end
  end

  def double_answer_helper
    geocode = Geocoder.coordinates("#{params["FromCity"]}, #{params["FromState"]}, #{params["FromZip"]}")
    message_body = params["Body"]
    @from_number = params["From"]
    user = User.find_by(phone_number: @from_number[2..-1])
    split_message = message_body.split(")")
    split_message[1] = split_message[1][1..-1]
    question = Question.find(split_message[0].to_i)
    double_split = split_message[1].split(',', 2)
    double_split[1] = double_split[1][1..-1]
      
    if (double_split[0].downcase == "y" || double_split[0].downcase == "yes" || double_split[0].downcase == "n" || double_split[0].downcase == "no") && double_split[1].to_i > 0
      double_split[0].downcase == "yes" || double_split[0].downcase == "ya" || double_split[0].downcase == "y" ? question.boolean_answers.create(response: true, latitude: geocode[0], longitude: geocode[1]) : question.boolean_answers.create(response: false, latitude: geocode[0], longitude: geocode[1])
      question.integer_answers.create(response: double_split[1], latitude: geocode[0], longitude: geocode[1])

    elsif double_split[0].downcase == "y" || double_split[0].downcase == "n" && double_split[1].to_i == 0
      double_split[0].downcase == "yes" || double_split[0].downcase == "ya" || double_split[0].downcase == "y" ? question.boolean_answers.create(response: true, latitude: geocode[0], longitude: geocode[1]) : question.boolean_answers.create(response: false, latitude: geocode[0], longitude: geocode[1])
      question.text_answers.create(response: double_split[1], latitude: geocode[0], longitude: geocode[1])

    elsif double_split[0].to_i > 0 
      question.integer_answers.create(response: double_split[0].to_i, latitude: geocode[0], longitude: geocode[1])
      question.text_answers.create(response: double_split[1], latitude: geocode[0], longitude: geocode[1])
    end
  end

  def triple_answer_helper
    geocode = Geocoder.coordinates("#{params["FromCity"]}, #{params["FromState"]}, #{params["FromZip"]}")
    message_body = params["Body"]
    @from_number = params["From"]
    user = User.find_by(phone_number: @from_number[2..-1])
    split_message = message_body.split(")")
    question = Question.find(split_message[0].to_i)

    double_split = split_message[1].split(',', 2)
    double_split[1] = double_split[1][1..-1]
    triple_split = double_split[1].split(',', 2)
    triple_split.unshift(double_split[0])
    triple_split[2] = triple_split[2][1..-1]

    triple_split[0].downcase == 'y' || triple_split[0].downcase == 'yes' || triple_split[0].downcase == 'ya' ? question.boolean_answers.create(response: true, latitude: geocode[0], longitude: geocode[1]) : question.boolean_answers.create(response: false, latitude: geocode[0], longitude: geocode[1])
    question.integer_answers.create(response: triple_split[1], latitude: geocode[0], longitude: geocode[1])
    question.text_answers.create(response: triple_split[2], latitude: geocode[0], longitude: geocode[1])
  end
end