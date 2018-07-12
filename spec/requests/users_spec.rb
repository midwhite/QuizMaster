require "rails_helper"
require "spec_helper"

describe V1::UsersController, type: :request do
  describe "sign_up" do
    let(:email) { Faker::Internet.email }
    let(:password) { Faker::Internet.password(8) }

    context "Normal Case" do
      it "creates new user and returns access token" do
        params = { user: { email: email, password: password, password_confirmation: password }}
        post sign_up_v1_users_url, params: params
        # check status code
        expect(response.code.to_i).to eq(201)
        # check access token creation
        result = JSON.parse(response.body, symbolize_names: true)
        expect(result[:user][:access_token]).to match(/\d+:[a-zA-Z0-9_\-]{20}/)
      end
    end

    context "Error Case" do
      example "email duplication error" do
        create(:user, email: email)
        params = { user: { email: email, password: password, password_confirmation: password }}
        post sign_up_v1_users_url, params: params
        # check status code
        expect(response.code.to_i).to eq(400)
        # check error message
        result = JSON.parse(response.body, symbolize_names: true)
        expect(result[:errors]).to include("email has already been taken")
      end
    end
  end
end
