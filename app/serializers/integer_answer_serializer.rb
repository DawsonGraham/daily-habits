class IntegerAnswerSerializer < ActiveModel::Serializer 
  attributes :id, :response, :question_id
end