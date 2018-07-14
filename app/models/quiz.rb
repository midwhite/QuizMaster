class Quiz < ApplicationRecord
  enum answer_type: [:selection]

  acts_as_paranoid

  belongs_to :user

  validates :title, presence: true
  validates :question, presence: true
  validate :has_answer?
  validate :has_no_script?

  def response
    {
      id: self.id,
      user: self.user.response,
      title: self.title,
      question: self.question,
      isSelection: self.is_selection,
      hasMultiAnswers: self.has_multi_answers,
      canScorePartial: self.can_score_partial,
      createdAt: I18n.l(self.created_at)
    }
  end

  def response_with_answer
    self.response.merge(
      answers: self.correct_answers,
      explanation: self.explanation
    )
  end

  def multi_answers
    JSON.parse(self.multi_answers_json)
  end

  def multi_answers=(answers)
    if !answers.kind_of?(Array)
      raise "multi_answers must be an array."
    end

    if !answers.all?{|element| element.kind_of?(String) }
      raise "all the elements of multi_answers must be string."
    end

    self.multi_answers_json = answers.to_json
  end

  # all answers that can be correct
  def correct_answers
    self.has_multi_answers ? self.multi_answers : [self.correct_answer]
  end

  def editable_by?(user)
    if user && user.id === self.user_id
      self.errors.add(:base, t("shared.errors.not_found"))
      return false
    else
      return true
    end
  end

  private
  def has_answer?
    if self.correct_answers.blank?
      self.errors.add(:correct_answer, t("shared.errors.is_required"))
    end
  end

  def has_no_script?
    # [TODO] prevent XSS on :questoin and :explanation
  end
end
