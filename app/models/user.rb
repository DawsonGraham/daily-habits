class User < ApplicationRecord
  has_many :questions
  has_many :boolean_answers, through: :questions
  has_many :integer_answers, through: :questions
  has_many :text_answers, through: :questions

  validates_presence_of :first_name, :last_name, :phone_number, :email, :password
  validates_uniqueness_of :email, :phone_number

  has_secure_password

end
