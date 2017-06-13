module TwilioHelper
  def single_answer_helper
    message_body = params["Body"]
    @from_number = params["From"]
    user = User.find_by(phone_number: @from_number[1..-1])
    split_message = message_body.split(")")
    question = Question.find(split_message[0].to_i)

    if split_message[1].downcase == "yes" || split_message[1].downcase == "ya" || split_message[1].downcase == "y" || split_message[1].downcase == "n" || split_message[1].downcase == "no"
       split_message[1].downcase == "yes" || split_message[1].downcase == "ya" || split_message[1].downcase == "y" ? question.boolean_answers.create(response: true) : question.boolean_answers.create(response: false)    
    elsif split_message[1].to_i > 0
      question.integer_answers.create(response: split_message[1].to_i)
    else
      question.text_answers.create(response: split_message[1])
    end
  end

  def double_answer_helper
    message_body = params["Body"]
    @from_number = params["From"]
    user = User.find_by(phone_number: @from_number[1..-1])
    split_message = message_body.split(")")
    split_message[1] = split_message[1][1..-1]
    question = Question.find(split_message[0].to_i)
    double_split = split_message[1].split(',', 2)
    double_split[1] = double_split[1][1..-1]
      
    if (double_split[0].downcase == "y" || double_split[0].downcase == "yes" || double_split[0].downcase == "n" || double_split[0].downcase == "no") && double_split[1].to_i > 0
      double_split[0].downcase == "yes" || double_split[0].downcase == "ya" || double_split[0].downcase == "y" ? question.boolean_answers.create(response: true) : question.boolean_answers.create(response: false)
      question.integer_answers.create(response: double_split[1])

    elsif double_split[0].downcase == "y" || double_split[0].downcase == "n" && double_split[1].to_i == 0
      double_split[0].downcase == "yes" || double_split[0].downcase == "ya" || double_split[0].downcase == "y" ? question.boolean_answers.create(response: true) : question.boolean_answers.create(response: false)
      question.text_answers.create(response: double_split[1])

    elsif double_split[0].to_i > 0 
      question.integer_answers.create(response: double_split[0].to_i)
      question.text_answers.create(response: double_split[1])
    end
  end

  def triple_answer_helper
    message_body = params["Body"]
    @from_number = params["From"]
    user = User.find_by(phone_number: @from_number[1..-1])
    split_message = message_body.split(")")
    question = Question.find(split_message[0].to_i)

    double_split = split_message[1].split(',', 2)
    double_split[1] = double_split[1][1..-1]
    triple_split = double_split[1].split(',', 2)
    triple_split.unshift(double_split[0])
    triple_split[2] = triple_split[2][1..-1]

    triple_split[0].downcase == 'y' || triple_split[0].downcase == 'yes' || triple_split[0].downcase == 'ya' ? question.boolean_answers.create(response: true) : question.boolean_answers.create(response: false)
    question.integer_answers.create(response: triple_split[1])
    question.text_answers.create(response: triple_split[2])
  end
end