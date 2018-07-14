class CreateQuizzes < ActiveRecord::Migration[5.2]
  def change
    create_table :quizzes do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.string :title, null: false
      t.text :question, null: false
      t.string :correct_answer
      t.text :multi_answers_json
      t.boolean :is_selection, null: false, default: false
      t.boolean :has_multi_answers, null: false, default: false
      t.boolean :can_score_partial, null: false, default: false
      t.text :explanation
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
