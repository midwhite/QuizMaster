require 'rails_helper'

RSpec.describe User, type: :model do
  describe "User#age" do
    context "birthday is nil" do
      example "user who doesn't have birthday returns nil as age" do
        user = build(:user, birthday: nil)
        expect(user.age).to be_nil
      end
    end

    context "birthday is present" do
      example "user who has birthday returns age" do
        user = build(:user, birthday: 18.years.ago)
        expect(user.age).to be(18)
      end
    end
  end

  describe "User#response" do
    let(:user) { build(:user) }

    example "User#response should not include profile, email, birthday, access_token" do
      result = [:profile, :email, :birthday, :access_token].all?{|prop| user.response[prop].nil? }
      expect(result).to be_truthy
    end

    example "User#detail should not include email, birthday, access_token" do
      result = [:email, :birthday, :access_token].all?{|prop| user.detail[prop].nil? }
      expect(result).to be_truthy
    end

    example "User#me should include email, birthday, access_token" do
      result = [:email, :birthday, :access_token].all?{|prop| user.me[prop].present? }
      expect(result).to be_truthy
    end
  end
end
