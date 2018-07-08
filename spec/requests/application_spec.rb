require "rails_helper"

describe ApplicationController, type: :request do
  describe "locale settings" do
    it "returns success message in English" do
      get root_url
      body = JSON.parse(response.body, symbolize_names: true)
      I18n.locale = :en
      expect(response.status).to eq(200)
      expect(body[:message]).to eq(I18n.t("application_controller.check.success"))
    end

    it "returns success message in Japanese" do
      get root_url(locale: :ja)
      body = JSON.parse(response.body, symbolize_names: true)
      I18n.locale = :ja
      expect(response.status).to eq(200)
      expect(body[:message]).to eq(I18n.t("application_controller.check.success"))
    end
  end
end
