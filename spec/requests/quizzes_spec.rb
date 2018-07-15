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
      expect(result[:quizzes]).to eq(quizzes.map(&:response_with_answer))
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
      quiz = create(:quiz, user: user)
      new_quiz_attr = attributes_for(:quiz)
      put v1_quiz_path(quiz), params: { quiz: new_quiz_attr }, headers: headers
      # check status code
      expect(response.code.to_i).to eq(200)
      # check data creation
      result = JSON.parse(response.body, symbolize_names: true)
      expect(result[:quiz][:title]).to eq(new_quiz_attr[:title])
      expect(result[:quiz][:question]).to eq(new_quiz_attr[:question])
      expect(result[:quiz][:correctAnswer]).to eq(new_quiz_attr[:correct_answer])
    end
  end

  describe "quizzes#destroy" do
    it "can destroy a quiz" do
      quiz = create(:quiz, user: user)
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
      it "can check correctness of answers" do
        quiz = create(:quiz, user: user, correct_answer: "I have a pen.")
        params = { answer: { content: "I have a pen." } }
        post v1_quiz_check_path(quiz), params: params, headers: headers

        result = JSON.parse(response.body, symbolize_names: true)
        expect(result[:result]).to eq(true)
      end

      it "can check incorrectness of answers" do
        quiz = create(:quiz, user: user, correct_answer: "I have a pen.")
        params = { answer: { content: "I have a pineapple." } }
        post v1_quiz_check_path(quiz), params: params, headers: headers

        result = JSON.parse(response.body, symbolize_names: true)
        expect(result[:result]).to eq(false)
      end

      it "can recognize words also in number" do
        quiz = create(:quiz, user: user, correct_answer: "I have 11 pens.")
        params = { answer: { content: "I have eleven pens." } }
        post v1_quiz_check_path(quiz), params: params, headers: headers

        result = JSON.parse(response.body, symbolize_names: true)
        expect(result[:result]).to eq(true)
      end

      it "can recognize numbers also in words" do
        quiz = create(:quiz, user: user, correct_answer: "I have eleven pens.")
        params = { answer: { content: "I have 11 pens." } }
        post v1_quiz_check_path(quiz), params: params, headers: headers

        result = JSON.parse(response.body, symbolize_names: true)
        expect(result[:result]).to eq(true)
      end
    end
  end
end
