Rails.application.routes.draw do
  devise_for :users, only: []
  root controller: :application, action: :check

  scope "/:locale" do
    namespace :v1, defaults: { format: :json } do
      resources :users, only: [:create] do
        get :me
      end
      resources :quizzes
    end
  end
end
