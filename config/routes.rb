ExpenseTracker::Application.routes.draw do

  devise_for :users
  

  resources :expenses

  resources :groups

  root to: "welcome#index"

end
