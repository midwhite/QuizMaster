class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :validatable

  enum gender: [:male, :female, :x_gender]

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
      birthday: self.birthday,
      access_token: self.access_token,
    )
  end

  def age
    date_format = "%Y%m%d"
    (Date.today.strftime(date_format).to_i - (self.birthday || Date.today).strftime(date_format).to_i) / 10000
  end

  private
  def set_access_token!
    self.access_token = "#{self.id}:#{Devise.friendly_token}"
    self.save
  end
end
