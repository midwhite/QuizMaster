class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :validatable

  enum gender: [:male, :female, :x_gender]

  acts_as_paranoid

  has_many :quizzes, dependent: :destroy

  after_create :set_access_token!

  def my_quizzes(user, query = {})
    quizzes = user.quizzes
    # search
    quizzes = quizzes.where(answer_type: query[:answer_type]) if query[:answer_type].present?
    quizzes = quizzes.search(title_or_question_or_explanation_cont_all: query[:keywords]).result if query[:keywords].present?
    # paging
    quizzes = quizzes.page(query[:page]) if query[:page].present?
    quizzes = quizzes.per(query[:limit] || 20) if query[:page].present?
    # response
    quizzes.eager_load(:user).order(id: :desc)
  end

  def response
    {
      id: self.id,
      name: self.name,
      gender: self.gender,
      age: self.age,
      area: self.area,
    }
  end

  def detail
    self.response.merge(
      profile: self.profile,
    )
  end

  def me
    self.detail.merge(
      email: self.email,
      birthday: (self.birthday && I18n.l(self.birthday) || ""),
      access_token: self.access_token,
    )
  end

  def age
    return nil if self.birthday.blank?
    date_format = "%Y%m%d"
    (I18n.l(Time.now).in_time_zone.strftime(date_format).to_i - self.birthday.strftime(date_format).to_i) / 10000
  end

  private
  def set_access_token!
    self.access_token = "#{self.id}:#{Devise.friendly_token}"
    self.save
  end
end
