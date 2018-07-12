Rails.application.routes.draw do
  devise_for :users, only: []
  root controller: :application, action: :check

  scope "/:locale", defaults: { locale: :en } do
    namespace :v1, defaults: { format: :json } do
      resources :users, only: [] do
        collection do
          post :sign_up
          post :login
          get :me
        end
      end
      resources :quizzes
    end
  end
end
