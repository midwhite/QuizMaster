class Quiz < ApplicationRecord
  acts_as_paranoid

  belongs_to :user

  validates :title, presence: true
  validates :question, presence: true
  validates :correct_answer, presence: true
  validate :has_answer?

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
      correctAnswer: self.correct_answer,
      explanation: self.explanation
    )
  end

  def editable_by?(user)
    return true if user && user.id === self.user_id

    self.errors.add(:base, I18n.t("shared.errors.not_found", resource: I18n.t("activerecord.models.quiz")))
    return false
  end

  def check(answer)
    # raise error if answer is not string
    raise "answer must be string." if !answer.kind_of?(String)
    # in case answer is equal to correct answer
    return true if self.correct_answer === answer
    # in case answer includes number
    user_answers = convert_num_to_words_list(answer)
    correct_answers = convert_num_to_words_list(self.correct_answer)
    return true if correct_answers.any?{|str| user_answers.include?(str) }
    # in other case
    return false
  end

  private
  def has_answer?
    if self.correct_answer.blank? && 
      self.errors.add(:correct_answer, I18n.t("shared.errors.is_required"))
    end
  end

  def convert_num_to_words_list(string)
    # list all patterns that convert from number to words
    result = [string]
    num_str = string.match(/\d+((,\d{3})+)?(\.\d+)?/).to_s
    if num_str.present?
      # use English to escape "Language not supported" error for Japanese
      # (normally Japanese don't use words for number)
      num_in_words = I18n.with_locale(:en) {
        base_num = num_str.delete(",").to_f
        words = []
        words << base_num.to_words
        words << base_num.to_words(remove_hyphen: true) # e.g. 41: "forty-two" -> "forty two"
        words << base_num.to_words(hundreds_with_union: true) # e.g. 111: "one hundred eleven" -> "one hundred and eleven"
        words << base_num.to_words(remove_zero: true) # e.g. 0.7: "zero and seven tenths" -> "one hundred eleven"
        words
      }

      num_in_words.select(&:present?).map do |num_in_word|
        result << string.gsub(num_str, num_in_word)
      end
    end
    # return unique patterns
    result.uniq
  end
end
