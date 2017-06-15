class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
      t.string :title, null: false
      t.boolean :text, null: false, default: false
      t.boolean :integer, null: false, default: false
      t.boolean :boolean, null: false, default: false
      t.references :user, foreign_key: true

      t.timestamps null: false
    end
  end
end


