require 'rails_helper'

RSpec.describe User, type: :model do
  describe "User#age" do
    context "birthday is nil" do
      example "age returns nil" do
        user = build(:user, birthday: nil)
        expect(user.age).to be_nil
      end
    end

    context "birthday is present" do
      example "age returns valid number" do
        user = build(:user, birthday: 18.years.ago)
        expect(user.age).to be(18)
      end
    end
  end
end
