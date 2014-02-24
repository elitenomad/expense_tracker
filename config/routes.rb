ExpenseTracker::Application.routes.draw do


  devise_for :users 

  resources :users, {shallow: true} do
  	resources :groups
  end
  
  resources :groups, {shallow: true} do
  	resources :expenses
  end

  resources :expenses, {shallow: true} do
  	resources :portions
  end

  get ':action', to: 'pages#action'  


  root to: "pages#index"

end
