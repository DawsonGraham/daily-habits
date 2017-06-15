class CreateTextAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :text_answers do |t|
      t.string :response, null: false
      t.references :question, foreign_key: true
      t.attachment :avatar
      t.string :ip_address
      t.float :latitude
      t.float :longitude
      
      t.timestamps null: false
    end
  end
end
