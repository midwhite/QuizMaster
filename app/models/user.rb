class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :validatable

  enum gender: [:male, :female, :x_gender]

  acts_as_paranoid

  after_create :set_access_token!

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
