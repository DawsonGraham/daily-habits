module TextAnswersHelper

  include TimezoneHelper

def day_check_text(q)
  n = 0
  day_hashes = []
  until n == 7
    check = []
    q.text_answers.each do |text|
      if text.created_at.strftime('%Y%m%d').to_i == time_converter.strftime('%Y%m%d').to_i - n
        check << text
      end
  end
    if check.empty?
      day_hashes << {(Chronic.parse("#{n} day ago").strftime('%a')) => false}
    else
      day_hashes << {(Chronic.parse("#{n} day ago").strftime('%a')) => check[0].response}
    end
    n += 1
  end
  day_hashes
end
end
