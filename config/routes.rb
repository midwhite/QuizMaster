Rails.application.routes.draw do
  root controller: :application, action: :check

  scope "/:locale" do
    namespace :v1, defaults: { format: :json } do
      resources :quizzes
    end
  end
end
