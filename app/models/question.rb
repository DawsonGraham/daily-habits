class Question < ApplicationRecord
  belongs_to :user
  has_many :boolean_answers
  has_many :integer_answers
  has_many :text_answers

  validates_presence_of :title
  validates_uniqueness_of :title


  def average_rating
    self.integer_answers.reduce(0) {|sum, answer| sum + answer.response }.to_f / self.integer_answers.length
  end

end
