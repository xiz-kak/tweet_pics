Rails.application.routes.draw do
  root 'pics#index'
  resources :pics, only: [:index, :new, :create]
  get 'post_pic/:id' => 'twitter#post_pic', as: :post_pic

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
