class V1::QuizzesController < ApplicationController
  def index
    render json: {
      quizzes: current_user.my_quizzes(current_user, params).map(&:response)
    }
  end

  def create
    quiz = Quiz.new(quiz_params)

    if quiz.save
      render status: :created, json: { quiz: quiz.response_with_answer }
    else
      render status: :bad_request, json: { errors: quiz.errors.full_messages }
    end
  end

  def update
    quiz = Quiz.find_by(params[:id])

    # check access permission
    unless quiz && quiz.editable_by?(current_user)
      render status: :bad_request, json: { errors: quiz.errors.full_messages } and return
    end

    if quiz.update(quiz_params)
      render json: { quiz: quiz.response_with_answer }
    else
      render status: :bad_request, json: { errors: quiz.errors.full_messages }
    end
  end

  def destroy
    quiz = Quiz.find_by(params[:id])

    # check access permission
    unless quiz && quiz.editable_by?(current_user)
      render status: :bad_request, json: { errors: quiz.errors.full_messages } and return
    end

    if quiz.destroy
      render json: { success: true }
    else
      render status: :bad_request, json: { errors: quiz.errors.full_messages }
    end
  end

  def check
    # [TODO] add the logic to check answers
    render json: {}
  end

  private
  def quiz_params
    params.fetch(:quiz, {}).permit(
      :title, :question, :correct_answer, :multi_answer_json, :explanation,
      :is_selection, :has_multi_answers, :can_score_partial
    ).merge(user_id: current_user.id)
  end
end
