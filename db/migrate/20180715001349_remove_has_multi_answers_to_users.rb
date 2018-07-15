class RemoveHasMultiAnswersToUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :quizzes, :is_selection, :boolean
    remove_column :quizzes, :has_multi_answers, :boolean
    remove_column :quizzes, :can_score_partial, :boolean
    remove_column :quizzes, :multi_answers_json, :text
  end

  def up
    change_column :quizzes, :correct_answer, :string, null: false
  end

  def down
    change_column :quizzes, :correct_answer, :string
  end
end
