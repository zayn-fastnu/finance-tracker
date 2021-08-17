Rails.application.routes.draw do
  resources :user_stocks, only: :create
  #devise_for :users
  root "welcome#index"
  get '/welcome', to: "welcome#index"
  get 'search_stock', to: "stocks#search"
  #get 'my_portfolio',to: 'users/sessions#my_portfolio'
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  devise_scope :user do
    get "my_portfolio" => "users/sessions"
    end
end

#do
 # devise_for :users
  #root "welcome#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
#end

