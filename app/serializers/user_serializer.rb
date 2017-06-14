class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :phone_number, :email

  has_many :questions
  has_many :boolean_answers, through: :questions
  has_many :integer_answers, through: :questions
  has_many :text_answers, through: :questions
end
