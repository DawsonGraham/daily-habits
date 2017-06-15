module QuestionsHelper
include TimezoneHelper

def day_check(q)
  n = 0
  day_hashes = []
  until n == 7
    check = []
    q.boolean_answers.each do |bool|
      if bool.created_at.strftime('%Y%m%d').to_i == time_converter.strftime('%Y%m%d').to_i - n && bool.response == true
        check << bool
      end
  end
    if check.empty?
      day_hashes << {(Chronic.parse("#{n} day ago").strftime('%a')) => false}
    else
      day_hashes << {(Chronic.parse("#{n} day ago").strftime('%a')) => true}
    end
    n += 1
  end
  day_hashes
end

end


