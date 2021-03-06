Rails.application.routes.draw do
  get 'home/create'
  post 'home/delete', as: 'delete'
  get 'home/login_link', as: 'content_login_link'

  root :to => 'home#index'
  mount ShopifyApp::Engine, at: '/'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
