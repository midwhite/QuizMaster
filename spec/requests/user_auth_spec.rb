require "rails_helper"
require "spec_helper"

describe V1::UsersController, type: :request do
  describe "sign_up" do
    let(:email) { Faker::Internet.email }
    let(:password) { Faker::Internet.password(8) }
    let(:params) {{ user: { email: email, password: password, password_confirmation: password }}}

    context "Normal Case" do
      it "creates new user and returns access token" do
        post sign_up_v1_users_url, params: params
        # check status code
        expect(response.code.to_i).to eq(201)
        # check access token creation
        result = JSON.parse(response.body, symbolize_names: true)
        expect(result[:user][:access_token]).to match(/\d+:[a-zA-Z0-9_\-]{20}/)
      end

      it "can sign up again as new user after unsubscription" do
        user = create(:user, password: password).destroy
        request_params = { user: { email: user.email, password: password, password_confirmation: password }}
        post sign_up_v1_users_url, params: request_params
        # check status code
        expect(response.code.to_i).to eq(201)
        # check access token creation
        result = JSON.parse(response.body, symbolize_names: true)
        expect(result[:user][:id].to_i).not_to eq(user.id)
      end
    end

    context "Error Case" do
      example "email duplication error" do
        create(:user, email: email)
        post sign_up_v1_users_url, params: params
        # check status code
        expect(response.code.to_i).to eq(400)
        # check error message
        result = JSON.parse(response.body, symbolize_names: true)
        expect(result[:errors]).to include("email has already been taken")
      end

      example "wrong password error" do
        wrong_params = params
        wrong_params[:user].merge!(password_confirmation: Faker::Internet.password)
        post sign_up_v1_users_url, params: wrong_params
        # check status code
        expect(response.code.to_i).to eq(400)
        # check error message
        result = JSON.parse(response.body, symbolize_names: true)
        expect(result[:errors]).to include("password (Confirmation) doesn't match password")
      end

      example "invalid params error" do
        post sign_up_v1_users_url, params: {}
        # check status code
        expect(response.code.to_i).to eq(400)
        # check error message
        result = JSON.parse(response.body, symbolize_names: true)
        expect(result[:errors]).to include("email can't be blank")
      end
    end
  end

  describe "login" do
    let(:email) { Faker::Internet.email }
    let(:password) { Faker::Internet.password(8) }
    let(:params) {{ user: { email: email, password: password }}}
    let(:user) { create(:user, password: password) }

    context "Normal Case" do
      it "succeeds in login" do
        post login_v1_users_url, params: { user: { email: user.email, password: password }}
        # check status code
        expect(response.code.to_i).to eq(200)
        # check response body
        result = JSON.parse(response.body, symbolize_names: true)
        expect(result).to eq({ user: user.me })
      end
    end

    context "Error Case" do
      example "unregistered email error" do
        post login_v1_users_url, params: params
        # check status code
        expect(response.code.to_i).to eq(404)
        # check error message
        result = JSON.parse(response.body, symbolize_names: true)
        expect(result[:errors]).to include(I18n.t("users_controller.login.email_not_found"))
      end

      example "wrong password error" do
        post login_v1_users_url, params: { user: { email: user.email, password: Faker::Internet.password(10) }}
        # check status code
        expect(response.code.to_i).to eq(400)
        # check error message
        result = JSON.parse(response.body, symbolize_names: true)
        expect(result[:errors]).to include(I18n.t("users_controller.login.wrong_password"))
      end
    end
  end

  describe "login" do
    context "Normal Case" do
      let(:user) { create(:user) }
      let(:headers) {{ Authorization: user.access_token }}

      it "succeeds in getting user information" do
        get me_v1_users_url, headers: headers
        result = JSON.parse(response.body, symbolize_names: true)
        # check status code
        expect(response.code.to_i).to eq(200)
        # check response body
        expect(result).to eq({ user: user.me })
      end
    end

    context "Error Case" do
      example "user can't get information without Authorization header" do
        user = create(:user)
        get me_v1_users_url, headers: {}
        # check status code
        expect(response.code.to_i).to eq(401)
        # check response body
        result = JSON.parse(response.body, symbolize_names: true)
        expect(result[:errors]).to include("You need to sign in or sign up before continuing.")
      end
    end
  end
end
