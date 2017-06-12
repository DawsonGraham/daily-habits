class User < ApplicationRecord
  before_create :generate_access_token
  has_many :questions
  has_many :boolean_answers, through: :questions
  has_many :integer_answers, through: :questions
  has_many :text_answers, through: :questions

  validates_presence_of :first_name, :last_name, :phone_number, :email
  validates_uniqueness_of :email, :phone_number
  validates :email, format: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :password, presence: true, length: { minimum: 6 }, confirmation: true
  has_secure_password

  def User.new_token
    SecureRandom.urlsafe_base64
  end


  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def recent_questions(num)
    self.questions.where(created_at: (Time.now - num.day)..Time.now)
  end

  def number_of_users_questions
    self.questions.count
  end

  private
    def generate_access_token
      begin
        self.access_token = User.new_token
      end while self.class.exists?(access_token: access_token)
    end
end
