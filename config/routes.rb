ExpenseTracker::Application.routes.draw do


  devise_for :users 

  resources :users, {shallow: true} do
  	resources :groups, only: [:new, :create, :destroy]
  end
  
  resources :groups, {shallow: true} do
  	resources :expenses
  end

  resources :expenses, {shallow: true} do
  	resources :portions
  end

  

  root to: "welcome#index"
  match "/groups/:id/adduser" => "groups#adduser", as: 'adduser', via: :post

end
