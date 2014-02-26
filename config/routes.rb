ExpenseTracker::Application.routes.draw do


  #get "users/index"
  devise_for :users 

  resources :users, {shallow: true} do
  	resources :groups, only: [:new, :create, :destroy]
  end
  
  resources :groups, {shallow: true} do
  	resources :expenses
    resources :settlements
  end

  resources :expenses, {shallow: true} do
  	resources :portions
  end

  resources :memberships

  get ':action', to: 'pages#action'  


  match "/groups/:id/adduser" => "groups#adduser", as: 'adduser', via: :post
  match "/groups/:id/index" => "users#index", as: 'groupuser', via: :get
  root to: "pages#index"
   

end
