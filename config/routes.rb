Delivery::Application.routes.draw do
  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations", :omniauth_callbacks => "omniauth_callbacks" }
  resources :users do 
    collection do 
      get :validate_your_data
      post :validate_mobile_phone
      post :send_sms
      post :validate_id_image
    end
  end
  match '/delivery' => 'delivery#zone', :via => [:get, :post]
end