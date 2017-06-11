class BooleanAnswer < ApplicationRecord
  belongs_to :question

  validates_presence_of :response
end
