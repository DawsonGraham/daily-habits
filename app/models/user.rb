class User < ApplicationRecord
  has_many :questions
  has_many :boolean_answers, through: :questions
  has_many :integer_answers, through: :questions
  has_many :text_answers, through: :questions
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"

  validates_attachment :avatar,
  content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] }
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
  validates_presence_of :first_name, :last_name, :phone_number, :email
  validates_uniqueness_of :email, :phone_number
  validates :email, format: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :password, presence: true, length: { minimum: 6 }, confirmation: true
  has_secure_password

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def recent_questions(num)
    self.questions.where(created_at: (Time.now - num.day)..Time.now)
  end

  def number_of_users_questions
    self.questions.count
  end

end
