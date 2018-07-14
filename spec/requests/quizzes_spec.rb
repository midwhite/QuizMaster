require "rails_helper"
require "spec_helper"

describe V1::QuizzesController, type: :request do
  let(:user) { create(:user, email: Faker::Internet.email) }
  let(:headers) {{ Authorization: user.access_token }}

  describe "quizzes#index" do
    it "can return quizes list in desc order" do
      quizzes = create_list(:quiz, 5, user: user).sort{|q1, q2| q2.id - q1.id }
      get v1_quizzes_path, headers: headers
      # check status code
      expect(response.code.to_i).to eq(200)
      # check response body
      result = JSON.parse(response.body, symbolize_names: true)
      expect(result[:quizzes]).to eq(quizzes.map(&:response))
    end
  end

  describe "quizzes#create" do
    it "can create new quiz" do
      # check data creation
      expect {
        post v1_quizzes_path, params: { quiz: attributes_for(:quiz) }, headers: headers
      }.to change(Quiz, :count).by(1)
      # check status code
      expect(response.code.to_i).to eq(201)
    end
  end

  describe "quizzes#update" do
    it "can update a quiz" do
      quiz = create(:quiz)
      new_quiz_attr = attributes_for(:quiz)
      put v1_quiz_path(quiz), params: { quiz: new_quiz_attr }, headers: headers
      # check status code
      expect(response.code.to_i).to eq(200)
      # check data creation
      result = JSON.parse(response.body, symbolize_names: true)
      [:title, :question, :explanation].each do |prop|
        expect(result[:quiz][prop]).to eq(new_quiz_attr[prop])
      end
    end
  end

  describe "quizzes#destroy" do
    it "can destroy a quiz" do
      quiz = create(:quiz)
      # check data creation
      expect {
        delete v1_quiz_path(quiz), headers: headers
      }.to change(Quiz, :count).by(-1)
      # check status code
      expect(response.code.to_i).to eq(200)
    end
  end

  describe "quizzes#check" do
    context "Normal Case" do
      xit "can check correctness of answers" do
        pending "Add spec for quizzes#check."
      end

      xit "can check correctness of multiple answers" do
        pending "Add spec for quizzes#check."
      end

      xit "can recognize numbers also in words" do
        pending "Add spec for quizzes#check."
      end
    end
  end
end
