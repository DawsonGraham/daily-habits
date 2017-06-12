class Question < ApplicationRecord
  belongs_to :user
  has_many :boolean_answers
  has_many :integer_answers
  has_many :text_answers

  validates_presence_of :title
  validates_uniqueness_of :title
end
