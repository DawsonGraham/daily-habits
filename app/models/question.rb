class Question < ApplicationRecord

  belongs_to :user
  has_many :boolean_answers, :dependent => :delete_all
  has_many :integer_answers, :dependent => :delete_all
  has_many :text_answers, :dependent => :delete_all

  # validate :option_selector
  validates_presence_of :title
  validates_uniqueness_of :title


  def average_rating
    self.integer_answers.reduce(0) {|sum, answer| sum + answer.response }.to_f / self.integer_answers.length
  end

  def total_tasks_completed
    count = []
    self.boolean_answers.each do |answer|
      if (answer.response == true)
        count << answer.id
      end
    end
    return count.length
  end

  def total_boolean_responses
    self.boolean_answers.count
  end

  def total_integer_responses
    self.integer_answers.count
  end

  def total_text_responses
    self.text_answers.count
  end

  def completion_rate
    (total_tasks_completed / total_boolean_responses).to_f
  end

  def created_time
    answer = self.text_answers[0].created_at.localtime.strftime("Answered on %m/%d/%Y at %I:%M%p")

  end

  def answer_characters
    self.text_answers[0].response.split().join('').length
  end

  def word_count
    self.text_answers[0].response.split().length
  end

end
