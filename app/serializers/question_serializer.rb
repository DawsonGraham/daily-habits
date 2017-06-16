class QuestionSerializer < ActiveModel::Serializer 
  attributes :id, :title

  has_many :boolean_answers
  has_many :integer_answers
  has_many :text_answers
end