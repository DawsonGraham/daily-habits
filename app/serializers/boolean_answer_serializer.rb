class BooleanAnswerSerializer < ActiveModel::Serializer
  attributes :id, :response, :question_id
end
