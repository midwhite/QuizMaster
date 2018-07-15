class Quiz < ApplicationRecord
  acts_as_paranoid

  belongs_to :user

  validates :title, presence: true
  validates :question, presence: true
  validates :correct_answer, presence: true
  validate :has_answer?
  validate :has_no_script?

  def response
    {
      id: self.id,
      user: self.user.response,
      title: self.title,
      question: self.question,
      createdAt: self.created_at.strftime(Constants::RESPONSE_DATETIME_FORMAT)
    }
  end

  def response_with_answer
    self.response.merge(
      answer: self.correct_answer,
      explanation: self.explanation
    )
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
    if self.correct_answer.blank? && 
      self.errors.add(:correct_answer, t("shared.errors.is_required"))
    end
  end

  def has_no_script?
    # [TODO] prevent XSS on :questoin and :explanation
  end
end
