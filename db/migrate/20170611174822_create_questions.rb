class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
      t.string :title, null: false
      t.boolean :text_answer, default: false
      t.boolean :integer_answer, default: false
      t.boolean :boolean_answer, default: false
      t.references :user, foreign_key: true

      t.timestamps null: false
    end
  end
end
