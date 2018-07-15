require 'rails_helper'

describe Quiz, type: :model do
  describe "Quiz#response" do
    example "Quiz#response returns response without error" do
      quiz = create(:quiz)
      expect{ quiz.response }.not_to raise_error
    end

    example "Quiz#response_with_answer returns response without error" do
      quiz = create(:quiz)
      expect{ quiz.response_with_answer }.not_to raise_error
    end
  end

  describe "Quiz#editable_by?" do
    it "is editable by self user" do
      quiz = create(:quiz)
      expect(quiz.editable_by?(quiz.user)).to be(true)
    end

    it "is not editable by other user" do
      quiz = create(:quiz)
      other_user = create(:user, email: Faker::Internet.email)
      expect(quiz.editable_by?(other_user)).to be(false)
    end

    it "is not editable by unlogined user" do
      quiz = create(:quiz)
      expect(quiz.editable_by?(nil)).to be(false)
    end
  end

  describe "Quiz#convert_num_to_words_list" do
    it "includes element that removed hyphen between tens and ones" do
      quiz = create(:quiz)
      result = quiz.send(:convert_num_to_words_list, "I have 42 dogs.")
      expect(result.length).to be(3)
      expect(result).to include("I have 42 dogs.")
      expect(result).to include("I have forty-two dogs.")
      expect(result).to include("I have forty two dogs.")
    end

    it "includes element that added 'and' between hundreds and tens" do
      quiz = create(:quiz)
      result = quiz.send(:convert_num_to_words_list, "I have 111 dogs.")
      expect(result.length).to be(3)
      expect(result).to include("I have 111 dogs.")
      expect(result).to include("I have one hundred and eleven dogs.")
      expect(result).to include("I have one hundred eleven dogs.")
    end

    it "includes element that removed 'zero' from integral part of float" do
      quiz = create(:quiz)
      result = quiz.send(:convert_num_to_words_list, "I have 0.7 dogs.")
      expect(result.length).to be(3)
      expect(result).to include("I have 0.7 dogs.")
      expect(result).to include("I have zero and seven tenths dogs.")
      expect(result).to include("I have seven tenths dogs.")
    end

    it "converts zero without errors" do
      quiz = create(:quiz)
      result = quiz.send(:convert_num_to_words_list, "I have 0 dog.")
      expect(result.length).to be(2)
      expect(result).to include("I have 0 dog.")
      expect(result).to include("I have zero dog.")
    end
  end

  describe "Quiz#check" do
    it "can recognize answer in number as words" do
      quiz = create(:quiz, correct_answer: "I have 111 dogs.")

      expect(quiz.check("I have 111 dogs.")).to eq(true)
      expect(quiz.check("I have one hundred and eleven dogs.")).to eq(true)
      expect(quiz.check("I have one hundred eleven dogs.")).to eq(true)
    end

    it "can recognize answer in words as number" do
      quiz = create(:quiz, correct_answer: "I have one hundred eleven dogs.")

      expect(quiz.check("I have one hundred eleven dogs.")).to eq(true)
      expect(quiz.check("I have 111 dogs.")).to eq(true)
    end

    it "can recognize answer in words as number" do
      quiz = create(:quiz, correct_answer: "I have one hundred and eleven dogs.")

      expect(quiz.check("I have one hundred and eleven dogs.")).to eq(true)
      expect(quiz.check("I have 111 dogs.")).to eq(true)
    end

    it "returns false when answer is incorrect" do
      quiz = create(:quiz, correct_answer: "I have an apple.")
      expect(quiz.check("I have no apple.")).to eq(false)
    end
  end
end
