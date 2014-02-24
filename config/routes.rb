ExpenseTracker::Application.routes.draw do

  resources :portions

  devise_for :users
  

  resources :expenses

  resources :groups

  root to: "welcome#index"

end
