ExpenseTracker::Application.routes.draw do

  post "/groups/:id/adduser" => "groups#adduser", as: 'adduser'
  get "/groups/:id/index" => "users#index", as: 'group_users'

  #get "users/index"
  devise_for :users 
  resources :activities
  resources :users, {shallow: true} do
  	resources :groups, only: [:new, :create, :destroy]
  end
  
  resources :groups do
  	resources :expenses
    resources :settlements
  end

  resources :expenses, {shallow: true} do
  	resources :portions
  end

  resources :memberships

  get ':action', to: 'pages#action'  

  post '/settlements/testing', to: 'settlements#testing'

  root to: "pages#index"
  get "about" => "static_pages#about"
  get "contact" => "static_pages#contact"

end
