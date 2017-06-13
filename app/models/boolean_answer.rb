class BooleanAnswer < ApplicationRecord
  belongs_to :question
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"

  validates_attachment :avatar,
  content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] }
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
  # validates_presence_of :response

  geocoded_by :ip_address
  after_validation :geocode


end
